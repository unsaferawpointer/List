//
//  ContentView + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 27.01.2026.
//

import SwiftUI

#if os(macOS)
// MARK: - View
extension ContentView: View {

	var body: some View {
		NavigationStack {
			List(selection: $model.selection) {
				Section {
					FilteredContentView(
						filter: model.filter,
						moveDisabled: model.filter.isEmpty
					) { item in
						buildMenu(item: item)
					}
					.onMove { indices, target in
	//					moveItems(with: indices, to: target)
					}
				}
			}
			.listStyle(.inset)
			.safeAreaBar(edge: .top) {
				ScrollView(.horizontal) {
					HStack {
						ForEach(tags) { tag in
							Toggle(isOn: .init(get: {
								model.filter.includedTag.contains(tag.uuid)
							}, set: { newValue in
								if newValue {
									model.filter.includedTag.insert(tag.uuid)
								} else {
									model.filter.includedTag.remove(tag.uuid)
								}
							})) {
								Label(tag.title, systemImage: tag.iconName.imageName ?? "tag")
							}
						}
					}
					.toggleStyle(.button)
				}
				.padding(.horizontal)
				.scrollIndicators(.hidden)
				.listRowSeparator(.hidden)
			}
//			.scrollIndicators(.hidden)
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button("Add", systemImage: "plus") {
						
					}
				}
			}
		}
	}
}

extension ContentView {

	@ViewBuilder
	func buildMenu(item: Item) -> some View {
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
//			deleteItem(item: item)
		} label: {
			Label(model.menuItemTitle(id: .delete), systemImage: "trash")
		}
	}
}
#endif
