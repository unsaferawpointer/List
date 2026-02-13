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
	var completionState: CompletionState = .any

	// MARK: - Initialization

	init(
		completionState: CompletionState = .any,
		includedTag: Set<UUID> = [],
		excludedTag: Set<UUID> = []
	) {
		self.completionState = completionState
		self.includedTag = includedTag
		self.excludedTag = excludedTag
	}
}

// MARK: - Codable
extension Filter: Codable { }

// MARK: - Hashable
extension Filter: Hashable { }

// MARK: - Nested Data Structs
extension Filter {

	enum CompletionState: Int, Codable {
		case include
		case exlude
		case any
	}
}

extension Filter {

	var isEmpty: Bool {
		includedTag.isEmpty && excludedTag.isEmpty
	}

	var predicate: Predicate<Item> {
		let count = includedTag.count

		let status: UInt8? = switch completionState {
		case .any:
			nil
		case .include:
			Status.done.rawValue
		case .exlude:
			Status.incomplete.rawValue
		}

		switch (includedTag.isEmpty, excludedTag.isEmpty) {
			case (true, true):
			guard let status else {
				return #Predicate<Item> { _ in true }
			}
			return #Predicate<Item> {
				$0.rawStatus == status
			}
		case (false, true):
			let base = #Predicate<Item> { item in
				item.tags?.filter { tag in
					includedTag.contains(tag.uuid)
				}.count == count
			}
			guard let status else {
				return base
			}
			return #Predicate<Item> { item in
				base.evaluate(item) && item.rawStatus == status
			}
		case (true, false):
			let base = #Predicate<Item> { item in
				item.tags?.contains { tag in
					excludedTag.contains(tag.uuid)
				} == false
			}
			guard let status else {
				return base
			}
			return #Predicate<Item> { item in
				base.evaluate(item) && item.rawStatus == status
			}
		case (false, false):
			let rhs = #Predicate<Item> { item in
				item.tags?.contains { tag in
					excludedTag.contains(tag.uuid)
				} == false
			}
			let base = #Predicate<Item> { item in
				item.tags?.filter { tag in
					includedTag.contains(tag.uuid)
				}.count == count && rhs.evaluate(item)
			}
			guard let status else {
				return base
			}
			return #Predicate<Item> { item in
				base.evaluate(item) && item.rawStatus == status
			}
		}
	}
}
