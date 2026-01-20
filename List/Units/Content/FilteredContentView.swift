//
//  FilteredContentView.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI
import SwiftData

struct FilteredContentView<V: View> {

	@Environment(\.modelContext) private var modelContext

	let editMode: EditMode

	let moveDisabled: Bool

	let menuBuilder: (Item) -> V

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

	init(tags: Set<UUID>, exclude: Set<UUID>, editMode: EditMode, moveDisabled: Bool, @ViewBuilder menuBuilder: @escaping (Item) -> V) {

		let normilized = tags.subtracting(exclude)

		let predicate = {
			if normilized.isEmpty && exclude.isEmpty {
				return #Predicate<Item> { _ in true }
			} else if normilized.isEmpty {
				return #Predicate<Item> { item in
					item.tags?.contains { tag in
						exclude.contains(tag.uuid)
					} == false
				}
			} else if exclude.isEmpty {
				return #Predicate<Item> { item in
					item.tags?.contains { tag in
						normilized.contains(tag.uuid)
					} == true
				}
			} else {
				return #Predicate<Item> { item in
					item.tags?.contains { tag in
						normilized.contains(tag.uuid) && !exclude.contains(tag.uuid)
					} == true
				}
			}
		}()

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
		self.menuBuilder = menuBuilder
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
					menuBuilder(item)
				}
		}
	}
}

#Preview {
	FilteredContentView(tags: [], exclude: [], editMode: .inactive, moveDisabled: false) { item in
		EmptyView()
	}
}
