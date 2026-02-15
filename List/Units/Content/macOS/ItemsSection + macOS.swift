//
//  ItemsSection + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 30.01.2026.
//

import SwiftUI
import SwiftData

#if os(macOS)
struct ItemsSection {

	@Environment(\.modelContext) var modelContext

	@Query private var items: [Item]

	let onMove: (Set<PersistentIdentifier>, Destination<PersistentIdentifier>) -> Void

	// MARK: - Initialization

	init(filter: Filter, onMove: @escaping (Set<PersistentIdentifier>, Destination<PersistentIdentifier>) -> Void = { _, _ in }) {
		self._items = Query(
			filter: filter.predicate,
			sort: [.byIndex, .byTimestamp],
			animation: .default
		)
		self.onMove = onMove
	}
}

// MARK: - View
extension ItemsSection: View {

	var body: some View {
		ForEach(items) { item in
			ItemView(item: item) { text in
				withAnimation {
					DataManager.updateItem(item, with: text, in: modelContext)
				}
			}
			.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
			.listRowSeparator(.hidden)
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
	ItemsSection(filter: Filter())
}

#endif
