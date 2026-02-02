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

	@AppStorage("filter") private var filterSettings: Data?

	@State var selection: Set<PersistentIdentifier> = []

	@Query(sort: [SortDescriptor<Item>.byIndex, .byTimestamp], animation: .default) var items: [Item]

	@State var scrollPosition: PersistentIdentifier?
}

// MARK: - Computed Properties
extension ContentView {

	var filter: Binding<Filter> {
		Binding {
			guard let data = filterSettings else {
				return Filter()
			}
			return (try? JSONDecoder().decode(Filter.self, from: data)) ?? Filter()
		} set: { newValue in
			guard let data = try? JSONEncoder().encode(newValue) else {
				filterSettings = nil
				return
			}
			filterSettings = data
		}
	}
}

// MARK: - View
extension ContentView: View {

	var body: some View {
		NavigationStack {
			ScrollViewReader { proxy in
				List(selection: $selection) {
					TagsSection(
						includedTags: filter.includedTag,
						excludedTags: filter.excludedTag
					)
					.padding(.init(top: 0, leading: 8, bottom: 8, trailing: 8))
					ItemsSection(filter: filter.wrappedValue)
				}
				.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
					buildMenu(for: selected)
				} primaryAction: { selected in

				}
				.onChange(of: scrollPosition) { oldValue, newValue in
					guard oldValue != newValue else {
						return
					}
					proxy.scrollTo(scrollPosition, anchor: .bottom)
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button("Add", systemImage: "plus") {
						addItem()
					}
				}
			}
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

private extension ContentView {

	func addItem() {
		withAnimation {
			let id = DataManager.addItem(with: "New Item", to: modelContext, all: items)
			withAnimation {
				scrollPosition = id
			}
		}
	}
}

// MARK: - Builders
private extension ContentView {

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		Toggle(sources: completionSources(for: selected), isOn: \.self) {
			Text("Completed")
		}
		.keyboardShortcut(.return, modifiers: .command)
		Divider()
		Menu {
			TagsPicker(selected: selected)
		} label: {
			Label("Tags...", systemImage: "tag")
		}
		Divider()
		Button(role: .destructive) {
			DataManager.deleteItems(selected, in: modelContext, all: items)
		} label: {
			Label("Delete", systemImage: "trash")
		}
		.keyboardShortcut(.delete, modifiers: .command)
	}
}
#endif
