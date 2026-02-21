//
//  ItemsSection + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 30.01.2026.
//

import SwiftUI
import SwiftData

struct ItemsSection<Row: View> {

	@Environment(\.modelContext) var modelContext

	@Query private var items: [Item]

	let onMove: (Set<PersistentIdentifier>, Destination<PersistentIdentifier>) -> Void

	let rowContent: (Item) -> Row

	// MARK: - Initialization

	init(
		filter: Filter,
		@ViewBuilder rowContent: @escaping (Item) -> Row,
		onMove: @escaping (Set<PersistentIdentifier>, Destination<PersistentIdentifier>) -> Void
	) {
		self._items = Query(
			filter: filter.predicate,
			sort: [.byIndex, .byTimestamp],
			animation: .default
		)
		self.rowContent = rowContent
		self.onMove = onMove
	}
}

// MARK: - View
extension ItemsSection: View {

	var body: some View {
		ForEach(items) { item in
			rowContent(item)
		}
		.onMove { indices, target in
			let ids = indices.map {
				items[$0].id
			}
			let destination: Destination<PersistentIdentifier> = if target == items.count {
				.after(id: items[target - 1].id)
			} else {
				.before(id: items[target].id)
			}
			onMove(Set(ids), destination)
		}
	}
}

#Preview {
	ItemsSection(filter: Filter()) { item in
		Text(item.text)
	} onMove: { _, _ in

	}
}
