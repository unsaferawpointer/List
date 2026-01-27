//
//  ContentView + iOS.swift
//  List
//
//  Created by Anton Cherkasov on 27.01.2026.
//

import SwiftUI
import SwiftData

#if os(iOS)
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
							TagsSection(tags: tags, filter: $model.filter)
						}
						Section {
							FilteredContentView(
								filter: model.filter,
								editMode: editMode,
								moveDisabled: model.filter.isEmpty
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
				model.navigationTitle(isEditMode: editMode == .active, tags: tags)
			)
			.navigationSubtitle(
				model.navigationSubtitle(isEditMode: editMode == .active, tags: tags, items: items)
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
#endif
