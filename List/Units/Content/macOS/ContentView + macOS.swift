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

	@Environment(\.modelContext) var modelContext

	@SceneStorage("filter") private var filterSettings: Data?

	@State var selection: Set<PersistentIdentifier> = []

	@Query(sort: [SortDescriptor<Item>.byIndex, .byTimestamp]) var items: [Item]

	@Query var tags: [Tag]

	@State var scrollPosition: PersistentIdentifier?

	let textFactory = TextFactory()

	@State private var isFilterPopoverPresented: Bool = false
}

// MARK: - Computed Properties
extension ContentView {

	var filter: Binding<Filter> {
		Binding {
			guard let data = filterSettings, let result = try? JSONDecoder().decode(Filter.self, from: data) else {
				return Filter()
			}
			return Filter(
				completionState: result.completionState,
				includedTag: result.includedTag.intersection(tags.map(\.uuid)),
				excludedTag: result.excludedTag.intersection(tags.map(\.uuid))
			)
		} set: { newValue in
			guard let data = try? JSONEncoder().encode(newValue) else {
				filterSettings = nil
				return
			}
			filterSettings = data
		}
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
			.navigationTitle(textFactory.makeTitle(filter: filter.wrappedValue, tags: tags))
			.navigationSubtitle(textFactory.makeSubtitle(filter: filter.wrappedValue, tags: tags, itemsCount: filteredItemsCount))
			.toolbar {
				buildToolbar()
			}
			.focusedValue(
				\.deleteAction,
				 ButtonAction<DeleteAction>(
					title: ContentLocalization.Menu.delete,
					isEnabled: !selection.isEmpty
				 ) {
					 deleteSelectedItems()
				 }
			)
			.focusedValue(
				\.completionAction,
				 ToggleAction(
					title: ContentLocalization.Menu.completed,
					isEnabled: !selection.isEmpty,
					source: completionSources(for: selection)
				 )
			)
		}
	}
}

// MARK: - Binding
private extension ContentView {

	func completionSources(for selected: Set<PersistentIdentifier>) -> [Binding<Bool>] {
		return items.filter { item in
			selected.contains(item.id)
		}.map { item in
			Binding {
				item.isCompleted
			} set: { newValue in
				item.isCompleted = newValue
			}
		}
	}
}

// MARK: - Helpers
private extension ContentView {

	func addItem() {
		withAnimation {
			let id = DataManager.addItem(
				with: ContentLocalization.defaultItemText,
				to: modelContext,
				all: items
			)
			withAnimation {
				scrollPosition = id
			}
		}
	}

	func deleteSelectedItems() {
		withAnimation {
			DataManager.deleteItems(selection, in: modelContext, all: items)
			selection.removeAll()
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
			List(selection: $selection) {
				ItemsSection(
					filter: filter.wrappedValue,
					selection: $selection
				) { item in
					ItemView(item: item) { text in
						withAnimation {
							DataManager.updateItem(item, with: text, in: modelContext)
						}
					}
					.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
					.listRowSeparator(.hidden)
				} onMove: { ids, destination in
					withAnimation {
						DataManager.moveItems(ids, to: destination, in: modelContext, all: items)
					}
				}
			}
			.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
				buildMenu(for: selected)
			}
			.onChange(of: scrollPosition) { oldValue, newValue in
				guard oldValue != newValue else {
					return
				}
				proxy.scrollTo(scrollPosition, anchor: .bottom)
			}
		}
	}

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		Toggle(sources: completionSources(for: selected), isOn: \.self) {
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
			DataManager.deleteItems(selected, in: modelContext, all: items)
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
			.popover(isPresented: $isFilterPopoverPresented, arrowEdge: .bottom) {
				FilterView(filter: filter)
					.presentationDetents([.medium, .large])
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
