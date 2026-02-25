//
//  ContentView + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 27.01.2026.
//

#if os(macOS)

import SwiftData
import SwiftUI

struct ContentView {

	@SceneStorage("filter") private var filterSettings: Data?

	// MARK: - SwiftData

	@Environment(\.modelContext) var modelContext

	@Query(sort: [SortDescriptor<Item>.byIndex, .byTimestamp])	var items:	[Item]
	@Query(sort: [SortDescriptor<Tag>.byIndex, .byTimestamp])	var tags:	[Tag]

	// MARK: - Presentation

	@State private var isFilterPopoverPresented: Bool = false

	// MARK: - Model

	@State var model = ContentModel()
}

// MARK: - Computed Properties
extension ContentView {

	var filter: Binding<Filter> {
		model.filter(from: $filterSettings, tags: tags)
	}
}

extension ContentView {

	var filteredItemsCount: Int {
		items.filter { (try? filter.wrappedValue.predicate.evaluate($0)) ?? false }.count
	}
}

// MARK: - View
extension ContentView: View {
	var body: some View {

		NavigationStack {
			buildContent()
				.overlay {
					if filteredItemsCount == 0 {
						ContentUnavailableView(
							makeUnavailableText(allCount: items.count, filteredCount: filteredItemsCount),
							systemImage: unavailableIcon(allCount: items.count, filteredCount: filteredItemsCount),
							description: Text(makeUnavailableMessage(allCount: items.count, filteredCount: filteredItemsCount))
						)
						.safeAreaPadding(.init(top: 34, leading: 0, bottom: 0, trailing: 0))
					}
				}
				.navigationTitle(model.title(for: filter.wrappedValue, tags: tags))
				.navigationSubtitle(
					model.subtitle(
						for: filter.wrappedValue,
						tags: tags,
						itemsCount: items.count
					)
				)
				.sheet(isPresented: $isFilterPopoverPresented) {
					FilterView(filter: filter)
						.presentationDetents([.medium, .large])
				}
			.toolbar {
				buildToolbar()
			}
			.focusedValue(
				\.deleteAction,
				 ButtonAction<DeleteAction>(
					title: ContentLocalization.Menu.delete,
					isEnabled: model.actionsIsEnabled
				 ) {
					 deleteSelectedItems()
				 }
			)
			.focusedValue(
				\.completionAction,
				 ToggleAction(
					title: ContentLocalization.Menu.completed,
					isEnabled: model.actionsIsEnabled,
					source: model.completionSources(for: items)
				 )
			)
		}
	}
}

// MARK: - Helpers
private extension ContentView {

	func addItem() {
		withAnimation {
			let id = DataManager.addItem(
				with: ContentLocalization.defaultItemText,
				filter: filter.wrappedValue,
				to: modelContext,
				all: items,
				allTags: tags
			)
			withAnimation {
				model.scrollPosition = id
			}
		}
	}

	func deleteSelectedItems() {
		withAnimation {
			model.deleteItems(in: modelContext, items: items)
		}
	}

	func makeUnavailableText(allCount: Int, filteredCount: Int) -> String {
		guard allCount > 0 else {
			return ContentLocalization.UnavailableContent.title
		}
		return filteredCount == 0
			? ContentLocalization.StrictFilter.text
			: ""
	}

	func makeUnavailableMessage(allCount: Int, filteredCount: Int) -> String {
		guard allCount > 0 else {
			return ContentLocalization.UnavailableContent.message
		}
		return filteredCount == 0
			? ContentLocalization.StrictFilter.message
			: ""
	}

	func unavailableIcon(allCount: Int, filteredCount: Int) -> String {
		guard allCount > 0 else {
			return "shippingbox"
		}
		return filteredCount == 0
			? "line.3.horizontal.decrease.circle"
			: "shippingbox"
	}
}

// MARK: - Builders
private extension ContentView {

	@ViewBuilder
	func buildContent() -> some View {
		ScrollViewReader { proxy in
			List(selection: $model.selection) {
				ItemsSection(
					filter: filter.wrappedValue,
					selection: $model.selection
				) { item in
					ItemView(item: item) { text in
						withAnimation {
							model.updateItem(item, with: text, in: modelContext)
						}
					}
					.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
					.listRowSeparator(.hidden)
				} onMove: { ids, destination in
					withAnimation {
						model.moveItems(ids, to: destination, in: modelContext, all: items)
					}
				}
			}
			.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
				buildMenu(for: selected)
			}
			.onChange(of: model.scrollPosition) { oldValue, newValue in
				guard oldValue != newValue else {
					return
				}
				proxy.scrollTo(model.scrollPosition, anchor: .bottom)
			}
		}
	}

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		Toggle(sources: model.completionSources(for: items), isOn: \.self) {
			Text(ContentLocalization.Menu.completed)
		}
		.keyboardShortcut(.return, modifiers: .command)
		Divider()
		Menu {
			TagsPicker(selected: selected)
		} label: {
			Label(ContentLocalization.Menu.tags, systemImage: "tag")
		}
		Divider()
		Button(role: .destructive) {
			withAnimation {
				model.deleteItems(ids: selected, in: modelContext, items: items)
			}
		} label: {
			Label(ContentLocalization.Menu.delete, systemImage: "trash")
		}
		.keyboardShortcut(.delete, modifiers: .command)
	}

	@ToolbarContentBuilder
	func buildToolbar() -> some ToolbarContent {
		ToolbarItem(placement: .automatic) {
			Button {
				isFilterPopoverPresented = true
			} label: {
				Label(
					FilterLocalization.NavigationBar.title,
					systemImage: filter.wrappedValue.isEmpty
					? "line.3.horizontal.decrease.circle"
					: "line.3.horizontal.decrease.circle.fill"
				)
			}
		}
		ToolbarItem(placement: .primaryAction) {
			Button("Add", systemImage: "plus") {
				addItem()
			}
		}
	}
}
#endif
