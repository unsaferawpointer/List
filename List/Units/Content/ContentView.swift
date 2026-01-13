//
//  ContentView.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {

	@State private var editMode: EditMode = .inactive

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
	) private var items: [Item]

	@Query(
		filter: nil,
		sort:
			[
				SortDescriptor(\Tag.index, order: .forward),
				SortDescriptor(\Tag.timestamp, order: .forward)
			],
		animation: .default
	) private var tags: [Tag]

	@State var model = ContentModel()

	var body: some View {
		NavigationStack {
			Group {
				if model.shouldContentUnavailableView(for: items) {
					ContentUnavailableView(
						model.contentUnavailableTitle(),
						systemImage: "shippingbox",
						description: Text(model.contentUnavailableMessage())
					)
				} else {
					List(selection: $model.selection) {
						if !tags.isEmpty {
							TagsSection(tags: tags, selectedTags: $model.selectedTags)
						}
						Section {
							FilteredContentView(tags: model.selectedTags, editMode: editMode, moveDisabled: !model.selectedTags.isEmpty) { item in
								Toggle(isOn: item.isOn) {
									Text(model.menuItemTitle(id: .status))
								}
								Divider()
								Button {
									self.model.presentedItem = item
								} label: {
									Label(model.menuItemTitle(id: .edit), systemImage: "pencil")
								}
								Button {
									self.model.presentedItemForTagsPicker = item
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
							.onMove { indices, target in
								moveItems(with: indices, to: target)
							}
						}
					}
					.listStyle(.inset)
				}
			}
			.navigationTitle(
				model.navigationTitle(isEditMode: editMode == .active, tags: tags)
			)
			.navigationSubtitle(
				model.navigationSubtitle(isEditMode: editMode == .active, tags: tags, items: items)
			)
			.sheet(isPresented: $model.isItemEditorPresented) {
				ItemDetails(title: model.itemEditorTitle(isNew: false), text: "") { newText in
					addItem(with: newText)
				}
			}
			.sheet(item: $model.presentedItem) { item in
				ItemDetails(title: model.itemEditorTitle(isNew: false), text: item.text) { newText in
					updateItem(item, newText: newText)
				}
			}
			.sheet(item: $model.presentedItemForTagsPicker) { item in
				TagsPicker(items: Set([item.id])) { selected in
					let filtered = tags.filter { item in
						selected.contains(item.id)
					}
					item.tags = filtered
				}
			}
			.sheet(isPresented: $model.isTagPickerPresented) {
				TagsPicker(items: model.selection) { selected in
					let filtered = tags.filter { item in
						selected.contains(item.id)
					}
//					item.tags = filtered
				}
			}
			.toolbar {
				buildToolbar()
			}
			.environment(\.editMode, $editMode)
		}
	}
}

// MARK: - Builders
extension ContentView {

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
private extension ContentView {

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
