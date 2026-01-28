//
//  ContentView.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import SwiftUI
import SwiftData


struct ContentView {

	#if os(iOS)
	@State var editMode: EditMode = .inactive
	#endif

	@Environment(\.modelContext) private var modelContext
	@Environment(\.undoManager) private var undoManager
	@Query(
		filter: nil,
		sort:
			[
				SortDescriptor(\Item.index, order: .forward),
				SortDescriptor(\Item.timestamp, order: .forward)
			],
		animation: .default
	) var items: [Item]

	@Query(
		filter: #Predicate<Tag> { tag in !tag.isHidden },
		sort:
			[
				SortDescriptor(\Tag.index, order: .forward),
				SortDescriptor(\Tag.timestamp, order: .forward)
			],
		animation: .default
	) var tags: [Tag]

	@State var model = ContentModel()

}

#if os(iOS)
// MARK: - Builders
extension ContentView {

	@ViewBuilder
	func buildMenu(item: Item) -> some View {
		Toggle(isOn: item.isOn) {
			Text(model.menuItemTitle(id: .status))
		}
		Divider()
		Button {
			model.editItem(item)
		} label: {
			Label(model.menuItemTitle(id: .edit), systemImage: "pencil")
		}
		Button {
			model.showTagsPicker(for: item)
		} label: {
			Label(model.menuItemTitle(id: .tags), systemImage: "tag")
		}
		Divider()
		Button(role: .destructive) {
			deleteItem(item: item)
		} label: {
			Label(model.menuItemTitle(id: .delete), systemImage: "trash")
		}
	}

	@ToolbarContentBuilder
	func buildToolbar() -> some ToolbarContent {
		#if os(iOS)
		ToolbarItem(placement: .topBarTrailing) {
			EditButton()
		}
		ToolbarItem(placement: .topBarTrailing) {
			Menu {
				Button {
					undoManager?.undo()
				} label: {
					Label("Undo", systemImage: "arrow.uturn.backward")
				}
				.disabled(undoManager?.canUndo == false)
				Button {
					undoManager?.redo()
				} label: {
					Label("Redo", systemImage: "arrow.uturn.forward")
				}
				.disabled(undoManager?.canRedo == false)
				Divider()
				NavigationLink {
					TagsEditor()
				} label: {
					Label("Tags...", systemImage: "tag")
				}
			} label: {
				Label("Common", systemImage: "ellipsis")
			}
			.disabled(editMode == .active)
		}
		ToolbarItem(placement: .bottomBar) {
			Spacer()
		}
		ToolbarItem(placement: .bottomBar) {
			if editMode == .active {
				Menu {
					Toggle(
						sources: completionSources(for: model.selection, in: items),
						isOn: \.self
					) {
						Text("Completed")
					}
					Divider()
					Button {
						self.model.isTagPickerPresented = true
					} label: {
						Label("Tags...", systemImage: "tag")
					}
					Divider()
					Button(role: .destructive) {
						deleteSelectedItems()
					} label: {
						Label("Delete", systemImage: "trash")
					}
				} label: {
					Label("Edit...", systemImage: "ellipsis")
				}
				.disabled(model.selection.isEmpty)
			} else {
				Button {
					showItemEditor()
				} label: {
					Label("Add Item", systemImage: "plus")
				}
			}
		}
		#endif
	}
}

// MARK: - Helpers
extension ContentView {

	func completionSources(for selected: Set<PersistentIdentifier>, in items: [Item]) -> [Binding<Bool>] {
		return items.filter { item in
			selected.contains(item.id)
		}.map { item in
			Binding {
				item.isCompleted
			} set: { newValue in
				item.isCompleted = newValue
				model.selection.remove(item.id)
				if model.selection.isEmpty {
					withAnimation {
						editMode = .inactive
					}
				}
			}
		}
	}

	func addItem(with text: String) {
		withAnimation {
			model.addItem(text: text, to: modelContext, allItems: items)
		}
	}

	func updateItem(_ item: Item, newText: String) {
		withAnimation {
			item.text = newText
		}
	}

	func showItemEditor() {
		withAnimation {
			self.model.isItemEditorPresented = true
		}
	}

	func deleteSelectedItems() {
		withAnimation {
			let filtered = items.filter {
				model.selection.contains($0.id)
			}
			model.selection.removeAll()
			for item in filtered {
				modelContext.delete(item)
			}
			editMode = .inactive
		}
	}

	func deleteItem(item: Item) {
		withAnimation {
			modelContext.delete(item)
		}
	}

	func moveItems(with indices: IndexSet, to target: Int) {
		withAnimation {
			var modificated = items
			modificated.move(fromOffsets: indices, toOffset: target)
			for (index, item) in modificated.enumerated() {
				item.index = index
			}
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Item.self, inMemory: true)
}
#endif
