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
	@Query(filter: nil, sort: \Item.index, animation: .default) private var items: [Item]

	let model = ContentModel()

	@State var scrollPosition: PersistentIdentifier?

	@State var text: String = "fdsfdsfd"

	@State var isPresented: Bool = false

	@State var selection: Set<PersistentIdentifier> = []

	var body: some View {
		NavigationStack {
			Group {
				if items.isEmpty {
					ContentUnavailableView(
						"No Items",
						systemImage: "shippingbox",
						description: Text("Add New Item")
					)
				} else {
					List(selection: $selection) {
						ForEach(items) { item in
							HStack(spacing: 16) {
								if editMode != .active {
									Circle()
										.foregroundStyle(item.isCompleted ? .secondary : .primary)
										.frame(width: 4, height: 4)
								}
								Text(item.text)
									.foregroundStyle(item.isCompleted ? .secondary : .primary)
									.lineLimit(2)
									.strikethrough(item.isCompleted)
							}
							.contextMenu {
								Toggle(isOn: .init(get: {
									item.isCompleted
								}, set: { newValue in
									item.isCompleted = newValue
								})) {
									Text("Completed")
								}
								Divider()
								Button(role: .destructive) {
									deleteItem(item: item)
								} label: {
									Label("Delete", systemImage: "trash")
								}
							}
						}
						.onMove { indices, target in
							moveItems(with: indices, to: target)
						}
					}
					.listStyle(.insetGrouped)
				}
			}
			.navigationTitle("All Items")
			.navigationSubtitle(editMode == .active ? "\(selection.count) Items Selected" : "\(items.count) Items")
			.sheet(isPresented: $isPresented) {
				ItemDetails(title: "New Item", text: "") { newText in
					withAnimation {
						let newItem = Item(timestamp: Date(), text: newText)
						for item in items {
							item.index += 1
						}
						modelContext.insert(newItem)
					}
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
		ToolbarItem(placement: .navigationBarTrailing) {
			EditButton()
		}
		if editMode != .active {
			ToolbarItemGroup(placement: .bottomBar) {
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
			}
		}
		ToolbarItem(placement: .bottomBar) {
			Spacer()
		}
		ToolbarItem(placement: .bottomBar) {
			if editMode == .active {
				Menu {
					Toggle(
						sources: completionSources(for: selection, in: items),
						isOn: \.self
					) {
						Text("Completed")
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
				.disabled(selection.isEmpty)
			} else {
				Button {
					addItem()
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
				// После изменения состояния - снимаем выделение
				selection.remove(item.id)
				// Если выделение пустое - выходим из режима редактирования
				if selection.isEmpty {
					withAnimation {
						editMode = .inactive
					}
				}
			}
		}
	}

	func addItem() {
		withAnimation {
			self.isPresented = true
		}
	}

	func deleteSelectedItems() {
		withAnimation {
			let filtered = items.filter {
				selection.contains($0.id)
			}
			selection.removeAll()
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
