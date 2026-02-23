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

	@State var editMode: EditMode = .inactive

	@SceneStorage("filter") private var filterSettings: Data?

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

	@State private var isFilterSheetPresented: Bool = false

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

extension ContentView {

	var filteredItems: [Item] {
		items.filter { (try? filter.wrappedValue.predicate.evaluate($0)) ?? false }
	}
}

// MARK: - View
extension ContentView: View {

	var body: some View {
		NavigationStack {
			Group {
				List(selection: $model.selection) {
					ItemsSection(
						filter: filter.wrappedValue,
						selection: $model.selection
					) { item in
						ItemView(item: item)
					} onMove: { ids, destination in
						withAnimation {
							DataManager.moveItems(
								ids,
								to: destination,
								in: modelContext,
								all: items
							)
						}
					}
				}
				.deleteDisabled(model.selection.isEmpty)
				.listStyle(.inset)
				.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
					buildMenu(for: selected)
				}
				.overlay {
					if filteredItems.count == 0 {
						ContentUnavailableView(
							makeUnavailableText(allCount: items.count, filteredCount: filteredItems.count),
							systemImage: unavailableIcon(allCount: items.count, filteredCount: filteredItems.count),
							description: Text(makeUnavailableMessage(allCount: items.count, filteredCount: filteredItems.count))
						)
						.safeAreaPadding(.init(top: 34, leading: 0, bottom: 0, trailing: 0))
					}
				}
			}
			.navigationTitle(
				model.navigationTitle(isEditMode: editMode == .active, tags: tags, filter: filter.wrappedValue)
			)
			.navigationSubtitle(
				model.navigationSubtitle(isEditMode: editMode == .active, tags: tags, items: filteredItems, filter: filter.wrappedValue)
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
			.sheet(isPresented: $isFilterSheetPresented) {
				FilterView(filter: filter)
			}
			.toolbar {
				buildToolbar()
			}
			.focusedValue(
				\.deleteAction,
				 ButtonAction<DeleteAction>(
					title: ContentLocalization.Menu.delete,
					isEnabled: !model.selection.isEmpty
				 ) {
					 deleteSelectedItems()
				 }
			)
			.focusedValue(
				\.completionAction,
				 ToggleAction(
					title: ContentLocalization.Menu.completed,
					isEnabled: !model.selection.isEmpty,
					source: completionSources(for: model.selection)
				 )
			)
			.environment(\.editMode, $editMode)
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

// MARK: - Builders
extension ContentView {

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		Toggle(sources: completionSources(for: selected), isOn: \.self) {
			Text(ContentLocalization.Menu.completed)
		}
		.keyboardShortcut(.return, modifiers: .command)
		Divider()
		if selected.count == 1 {
			Button {
				guard let item = items.first(where: { selected.contains($0.id) }) else {
					return
				}
				model.editItem(item)
			} label: {
				Label(ContentLocalization.Menu.edit, systemImage: "pencil")
			}
			Button {
				guard let item = items.first(where: { selected.contains($0.id) }) else {
					return
				}
				model.showTagsPicker(for: item)
			} label: {
				Label(ContentLocalization.Menu.tags, systemImage: "tag")
			}
			Divider()
		}
		Button(role: .destructive) {
			withAnimation {
				DataManager.deleteItems(selected, in: modelContext, all: items)
			}
		} label: {
			Label(ContentLocalization.Menu.delete, systemImage: "trash")
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
					Label(ContentLocalization.Menu.undo, systemImage: "arrow.uturn.backward")
				}
				.disabled(undoManager?.canUndo == false)
				Button {
					undoManager?.redo()
				} label: {
					Label(ContentLocalization.Menu.redo, systemImage: "arrow.uturn.forward")
				}
				.disabled(undoManager?.canRedo == false)
				Divider()
				NavigationLink {
					TagsEditor()
				} label: {
					Label(ContentLocalization.Menu.tags, systemImage: "tag")
				}
			} label: {
				Label(ContentLocalization.Toolbar.main, systemImage: "ellipsis")
			}
			.disabled(editMode == .active)
		}
		ToolbarItem(placement: .bottomBar) {
			if editMode != .active {
				Button {
					isFilterSheetPresented = true
				} label: {
					Label(
						FilterLocalization.NavigationBar.title,
						systemImage: filterToolbarIconName(for: filter.wrappedValue)
					)
				}
			}
		}
		if editMode == .active {
			ToolbarItem(placement: .bottomBar) {
				Button(ContentLocalization.Toolbar.selectAll) {
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
						Text(ContentLocalization.Menu.completed)
					}
					Divider()
					Button {
						self.model.isTagPickerPresented = true
					} label: {
						Label(ContentLocalization.Menu.tags, systemImage: "tag")
					}
					Divider()
					Button(role: .destructive) {
						deleteSelectedItems()
					} label: {
						Label(ContentLocalization.Menu.delete, systemImage: "trash")
					}
				} label: {
					Label(ContentLocalization.Toolbar.main, systemImage: "ellipsis")
				}
				.disabled(model.selection.isEmpty)
			} else {
				Button {
					showItemEditor()
				} label: {
					Label(ContentLocalization.Toolbar.add, systemImage: "plus")
				}
			}
		}
		#endif
	}
}

// MARK: - Helpers
extension ContentView {

	func filterToolbarIconName(for filter: Filter) -> String {
		filter.isEmpty
			? "line.3.horizontal.decrease.circle"
			: "line.3.horizontal.decrease.circle.fill"
	}

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

	func makeUnavailableText(allCount: Int, filteredCount: Int) -> String {
		guard allCount > 0 else {
			return ContentLocalization.ContentUnavailable.title
		}
		return filteredCount == 0
			? ContentLocalization.StrictFilter.text
			: ""
	}

	func makeUnavailableMessage(allCount: Int, filteredCount: Int) -> String {
		guard allCount > 0 else {
			return ContentLocalization.ContentUnavailable.message
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

	func completedStateForSelection() -> Bool {
		let selectedItems = items.filter { item in
			model.selection.contains(item.id)
		}
		return !selectedItems.isEmpty && selectedItems.allSatisfy(\.isCompleted)
	}

	func setCompletedForSelection(_ isCompleted: Bool) {
		withAnimation {
			items.filter { item in
				model.selection.contains(item.id)
			}.forEach { item in
				item.isCompleted = isCompleted
			}
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: Item.self, inMemory: true)
}
#endif
