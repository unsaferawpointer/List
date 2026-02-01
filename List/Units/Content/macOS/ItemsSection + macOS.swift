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

	// MARK: - Initialization

	init(filter: Filter) {
		self._items = Query(
			filter: filter.predicate,
			sort: [.byIndex, .byTimestamp],
			animation: .default
		)
	}
}

// MARK: - View
extension ItemsSection: View {

	var body: some View {
		ForEach(items) { item in
			ItemView(item: item) { text in
				withAnimation {
					guard !text.isEmpty else {
						modelContext.delete(item)
						return
					}
					item.text = text
				}
			}
			.listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
			.listRowSeparator(.hidden)
		}
	}
}

#Preview {
	ItemsSection(filter: Filter())
}

#endif
