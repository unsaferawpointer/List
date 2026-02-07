//
//  ContentView.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

#if os(iOS)
import SwiftUI
import SwiftData

struct ContentView {

	#if os(iOS)
	@State var editMode: EditMode = .inactive
	#endif

	@AppStorage("filter") private var filterSettings: Data?

	@Environment(\.modelContext) var modelContext
	@Environment(\.undoManager) private var undoManager

	@Query(sort: [SortDescriptor<Item>.byIndex, .byTimestamp], animation: .default) var items: [Item]

	@Query(
		filter: #Predicate<Tag> { tag in !tag.isHidden },
		sort: [.byIndex, .byTimestamp],
		animation: .default
	) var tags: [Tag]

	@State var scrollPosition: PersistentIdentifier?

	@State var model = ContentModel()

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
			Group {
				if model.shouldContentUnavailableView(for: items) {
					ContentUnavailableView(
						model.contentUnavailableTitle(),
						systemImage: "shippingbox",
						description: Text(model.contentUnavailableMessage())
					)
				} else {
					List(selection: $model.selection) {
						if !tags.isEmpty && editMode != .active {
							TagsSection(tags: tags, filter: filter)
						}
						Section {
							FilteredContentView(
								filter: filter.wrappedValue,
								editMode: editMode,
								moveDisabled: filter.wrappedValue.isEmpty
							) { item in
								buildMenu(item: item)
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
				model.navigationTitle(isEditMode: editMode == .active, tags: tags, filter: filter.wrappedValue)
			)
			.navigationSubtitle(
				model.navigationSubtitle(isEditMode: editMode == .active, tags: tags, items: items, filter: filter.wrappedValue)
			)
			.sheet(isPresented: $model.isItemEditorPresented) {
				ItemDetails(title: model.itemEditorTitle(isNew: true), text: "") { newText in
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
				TagsPicker(items: model.selection) { _ in }
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
		if editMode == .active {
			ToolbarItem(placement: .bottomBar) {
				Button("Select All") {
					selectAll()
				}
			}
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

	func selectAll() {
		withAnimation {
			model.selectAll(items: items)
		}
	}

	func addItem(with text: String) {
		withAnimation {
			_ = DataManager.addItem(with: text, to: modelContext, all: items)
		}
	}

	func updateItem(_ item: Item, newText: String) {
		withAnimation {
			DataManager.updateItem(item, with: newText, in: modelContext)
		}
	}

	func showItemEditor() {
		withAnimation {
			self.model.isItemEditorPresented = true
		}
	}

	func deleteSelectedItems() {
		withAnimation {
			DataManager.deleteItems(
				model.selection,
				in: modelContext,
				all: items
			)
			model.selection.removeAll()
			editMode = .inactive
		}
	}

	func deleteItem(item: Item) {
		withAnimation {
			DataManager.deleteItem(item, in: modelContext)
		}
	}

	func moveItems(with indices: IndexSet, to target: Int) {
		withAnimation {
			DataManager.moveItems(indices, to: target, in: modelContext, all: items)
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Item.self, inMemory: true)
}
#endif
