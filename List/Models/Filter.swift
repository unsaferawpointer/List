//
//  Filter.swift
//  List
//
//  Created by Anton Cherkasov on 25.01.2026.
//

import Foundation

struct Filter {

	var includedTag: Set<UUID>
	var excludedTag: Set<UUID>

	// MARK: - Initialization

	init(includedTag: Set<UUID> = [], excludedTag: Set<UUID> = []) {
		self.includedTag = includedTag
		self.excludedTag = excludedTag
	}
}

// MARK: - Codable
extension Filter: Codable { }

// MARK: - Hashable
extension Filter: Hashable { }

extension Filter {

	var isEmpty: Bool {
		includedTag.isEmpty && excludedTag.isEmpty
	}

	var predicate: Predicate<Item> {
		let count = includedTag.count
		switch (includedTag.isEmpty, excludedTag.isEmpty) {
			case (true, true):
			return #Predicate<Item> { _ in true }
		case (false, true):
			return #Predicate<Item> { item in
				item.tags?.filter { tag in
					includedTag.contains(tag.uuid)
				}.count == count
			}
		case (true, false):
			return #Predicate<Item> { item in
				item.tags?.contains { tag in
					excludedTag.contains(tag.uuid)
				} == false
			}
		case (false, false):
			let rhs = #Predicate<Item> { item in
				item.tags?.contains { tag in
					excludedTag.contains(tag.uuid)
				} == false
			}
			return #Predicate<Item> { item in
				item.tags?.filter { tag in
					includedTag.contains(tag.uuid)
				}.count == count && rhs.evaluate(item)
			}
		}
	}
}
