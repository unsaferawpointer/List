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

	let model = ContentModel()

	@State var isPresented: Bool = false

	@State var selection: Set<PersistentIdentifier> = []

	@State var selectedTags: Set<UUID> = []

	var body: some View {
		NavigationStack {
			Group {
				if model.shouldContentUnavailableView(for: items) {
					ContentUnavailableView(
						"No Items",
						systemImage: "shippingbox",
						description: Text("Add New Item")
					)
				} else {
					List(selection: $selection) {
						if !tags.isEmpty {
							ScrollView(.horizontal) {
								HStack {
									ForEach(tags) { tag in
										Button {
											withAnimation {
												if selectedTags.contains(tag.uuid) {
													selectedTags.remove(tag.uuid)
												} else {
													selectedTags.insert(tag.uuid)
												}
											}
										} label: {
											Text(tag.title)
												.font(.callout)
												.fontWeight(.semibold)
												.padding(.horizontal)
												.padding([.top, .bottom], 6)
												.background {
													Capsule(style: .continuous)
														.fill(
															!selectedTags.contains(tag.uuid)
																? Color(uiColor: .quaternarySystemFill)
																: Color(uiColor: .tintColor).opacity(0.1)
														)
												}
										}
										.buttonStyle(.plain)

									}
								}
							}
							.scrollIndicators(.hidden)
							.listRowSeparator(.hidden)
						}
						Section {
							FilteredContentView(tags: selectedTags, editMode: editMode, moveDisabled: !selectedTags.isEmpty)
								.onMove { indices, target in
									moveItems(with: indices, to: target)
								}
						}
					}
					.listStyle(.inset)
				}
			}
			.navigationTitle(
				model.navigationTitle(
					isEditMode: editMode == .active,
					selection: selection,
					tags: tags,
					selected: selectedTags
				)
			)
			.navigationSubtitle(
				model.navigationSubtitle(
					isEditMode: editMode == .active,
					selection: selection,
					tags: tags,
					selected: selectedTags
				) ?? "\(items.count) Items"
			)
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
