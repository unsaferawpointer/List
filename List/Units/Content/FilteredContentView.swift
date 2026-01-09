//
//  FilteredContentView.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI
import SwiftData

struct FilteredContentView {

	@Environment(\.modelContext) private var modelContext

	let editMode: EditMode

	let moveDisabled: Bool

	@Query(
		filter: nil,
		sort:
			[
				SortDescriptor(\Item.index, order: .forward),
				SortDescriptor(\Item.timestamp, order: .forward)
			],
		animation: .default
	) private var filteredItems: [Item]

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

	@State var presentedItem: Item?

	// MARK: - Initialization

	init(tags: Set<UUID>, editMode: EditMode, moveDisabled: Bool) {

		let predicate = #Predicate<Item> { item in
			item.tags.filter { tag in
				tags.contains(tag.uuid)
			}.count == tags.count
		}

		self._filteredItems = Query(
			filter: predicate,
			sort:
				[
					SortDescriptor(\Item.index, order: .forward),
					SortDescriptor(\Item.timestamp, order: .forward)
				],
			animation: .default
		)
		self.editMode = editMode
		self.moveDisabled = moveDisabled
	}
}

// MARK: - View
extension FilteredContentView: View, DynamicViewContent {

	var data: Array<Item> {
		filteredItems
	}

	typealias Data = Array<Item>

	var body: some View {
		ForEach(filteredItems) { item in
			ItemView(isEditing: editMode == .active, item: item)
				.moveDisabled(moveDisabled)
				.contextMenu {
					Button {

					} label: {
						Text("Edit...")
					}
					Divider()
					Toggle(isOn: item.isOn) {
						Text("Completed")
					}
					Button {
						self.presentedItem = item
					} label: {
						Label("Tags...", systemImage: "tag")
					}
					Divider()
					Button(role: .destructive) {
						//					deleteItem(item: item)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
		}
		.sheet(item: $presentedItem) { item in
			TagsPicker(selected: Set(item.tags.map(\.id))) { selected in
				let filtered = tags.filter { item in
					selected.contains(item.id)
				}
				item.tags = filtered
			}
		}
	}
}

#Preview {
	FilteredContentView(tags: [], editMode: .inactive, moveDisabled: false)
}
