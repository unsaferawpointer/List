//
//  TagsPicker + Model.swift
//  List
//
//  Created by Anton Cherkasov on 28.01.2026.
//

import Foundation
import SwiftData

extension TagsPicker {

	@Observable
	final class Model {

		var selectedItems: Set<PersistentIdentifier>

		private(set) var changes: [PersistentIdentifier: Bool] = [:]

		// MARK: - Initialization

		init(selectedItems: Set<PersistentIdentifier>) {
			self.selectedItems = selectedItems
		}
	}
}

// MARK: - Public Interface
extension TagsPicker.Model {

	func showPlaceholder(for tags: [Tag]) -> Bool {
		return tags.isEmpty
	}

	var navigationTitle: String {
		String(localized: "navigation-title", table: "TagsPickerLocalizable")
	}

	var placeholderTitle: String {
		String(localized: "placeholder-title", table: "TagsPickerLocalizable")
	}

	var placeholderMessage: String {
		String(localized: "placeholder-message", table: "TagsPickerLocalizable")
	}
}

extension TagsPicker.Model {

	func save(items: [Item], tags: [Tag]) {
		for (key, value) in changes {
			for item in items {
				if value, let tag = tags.first(where: { $0.id == key }) {
					item.tags?.append(tag)
				} else {
					item.tags?.removeAll(where: { $0.id == key })
				}
			}
		}
	}

	func toggleState(for tag: PersistentIdentifier, items: [Item]) {
		if let value = changes[tag] {
			changes[tag] = !value
			return
		}

		var checkedCount = 0
		var uncheckedCount = 0

		for item in items {
			guard let tags = item.tags else {
				continue
			}
			if tags.map(\.id).contains(tag) {
				checkedCount += 1
			} else {
				uncheckedCount += 1
			}
		}

		changes[tag] = checkedCount == items.count ? false : true
	}

	func sources(for tag: PersistentIdentifier, items: [Item]) -> ControlState {
		if let value = changes[tag] {
			return value ? .on : .off
		}

		var checkedCount = 0
		var uncheckedCount = 0

		for item in items {
			guard let tags = item.tags else {
				continue
			}
			if tags.map(\.id).contains(tag) {
				checkedCount += 1
			} else {
				uncheckedCount += 1
			}
		}

		if checkedCount == items.count {
			return .on
		} else if uncheckedCount == items.count {
			return .off
		} else {
			return .mixed
		}
	}
}
