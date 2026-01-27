//
//  FilteredContentView + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 27.01.2026.
//

import SwiftUI
import SwiftData

#if os(macOS)
struct FilteredContentView<V: View> {

	@Environment(\.modelContext) private var modelContext

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

	init(filter: Filter, moveDisabled: Bool, @ViewBuilder menuBuilder: @escaping (Item) -> V) {

		self._filteredItems = Query(
			filter: filter.predicate,
			sort:
				[
					SortDescriptor(\Item.index, order: .forward),
					SortDescriptor(\Item.timestamp, order: .forward)
				],
			animation: .default
		)
		self.moveDisabled = moveDisabled
		self.menuBuilder = menuBuilder
	}
}

// MARK: - View
extension FilteredContentView: View {

	var body: some View {
		if filteredItems.isEmpty {
			ContentUnavailableView(
				"No Tasks",
				systemImage: "shippingbox",
				description: Text("Tap \"+\" to add your first task.")
			)
		} else {
			ForEach(filteredItems) { item in
				ItemView(item: item)
					.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
					.listRowSeparator(.hidden)
					.moveDisabled(moveDisabled)
					.contextMenu {
						menuBuilder(item)
					}
			}
		}
	}
}

// MARK: - DynamicViewContent
extension FilteredContentView: DynamicViewContent {

	var data: Array<Item> {
		filteredItems
	}

	typealias Data = Array<Item>
}

#Preview {
	FilteredContentView(filter: .init(includedTag: [], excludedTag: []), moveDisabled: false) { item in
		EmptyView()
	}
}
#endif
