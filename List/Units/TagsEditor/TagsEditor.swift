//
//  TagsEditor.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import SwiftUI
import SwiftData

struct TagsEditor: View {

	@Environment(\.modelContext) private var modelContext
	@Query(sort: \Tag.index, order: .forward, animation: .default) private var tags: [Tag]

	@State var selection: Set<PersistentIdentifier> = []

	@State private var editMode: EditMode = .inactive

	@State var presented: Tag?

	@State var isPresented: Bool = false

	let model = Model()

	var body: some View {
		Group {
			if tags.isEmpty {
				ContentUnavailableView(
					"No tags yet",
					systemImage: "tag",
					description: Text("Tap the + button to create your first tag")
				)
			} else {
				List(selection: $selection) {
					ForEach(tags) { tag in
						HStack {
							if editMode == .inactive {
								Image(systemName: tag.iconName.imageName ?? "tag")
									.foregroundStyle(tag.isHidden ? .tertiary : .primary)
							}
							Text(tag.title)
								.foregroundStyle(tag.isHidden ? .tertiary : .primary)
							Spacer()
						}
						.contextMenu {
							buildMenu(for: [tag.id])
						}
					}
					.onMove { indices, target in
						withAnimation {
							model.moveTags(tags, indices: indices, to: target)
						}
					}
				}
				.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
					buildMenu(for: selected)
				}
				.listStyle(.insetGrouped)
			}
		}
		.sheet(isPresented: $isPresented) {
			TagEditor(title: "New Tag", model: .init(name: "", iconName: .none)) { newModel in
				withAnimation {
					model.addTag(with: newModel.name, iconName: newModel.iconName, to: modelContext, allTags: tags)
				}
			}
		}
		.sheet(item: $presented) { tag in
			TagEditor(title: "Edit Tag", model: .init(name: tag.title, iconName: tag.iconName)) { newModel in
				tag.title = newModel.name
				tag.iconName = newModel.iconName
			}
		}
		.navigationTitle("All Tags")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				EditButton()
			}
			ToolbarItem(placement: .bottomBar) {
				Spacer()
			}
			ToolbarItem(placement: .bottomBar) {
				if editMode == .active {
					Menu {
						Button {
							setVisibility(selected: selection, newValue: true)
						} label: {
							Label("Hide", systemImage: "eye.slash")
						}
						Button {
							setVisibility(selected: selection, newValue: false)
						} label: {
							Label("Unhide", systemImage: "eye")
						}
						Divider()
						Button(role: .destructive) {
							deleteTags(selected: selection)
						} label: {
							Label("Delete", systemImage: "trash")
						}
					} label: {
						Label("Edit...", systemImage: "ellipsis")
					}
					.disabled(selection.isEmpty)
				} else {
					Button(action: addTag) {
						Label("Add Item", systemImage: "plus")
					}
				}
			}
		}
		.environment(\.editMode, $editMode)
	}
}

// MARK: - Helpers
private extension TagsEditor {

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		if let first = selected.first, selected.count == 1 {
			Button("Edit...") {
				self.presented = tags.first(where: { $0.id == first })
			}
		}
		Divider()
		Button {
			setVisibility(selected: selected, newValue: true)
		} label: {
			Label("Hide", systemImage: "eye.slash")
		}
		Button {
			setVisibility(selected: selected, newValue: false)
		} label: {
			Label("Unhide", systemImage: "eye")
		}
		Divider()
		Button(role: .destructive) {
			deleteTags(selected: selected)
		} label: {
			Text("Delete")
		}
	}
}

// MARK: - Helpers
private extension TagsEditor {

	func setVisibility(selected: Set<PersistentIdentifier>, newValue: Bool) {
		withAnimation {
			editMode = .inactive
			tags.filter {
				selected.contains($0.id)
			}.forEach {
				$0.isHidden = newValue
			}
		}
	}

	func addTag() {
		withAnimation {
			self.isPresented = true
		}
	}

	func deleteTags(selected: Set<PersistentIdentifier>) {
		withAnimation {
			editMode = .inactive
			model.deleteTags(selected: selected, in: modelContext)
		}
	}
}

#Preview {
	TagsEditor()
		.modelContainer(for: Tag.self, inMemory: true)
}
