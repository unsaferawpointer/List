//
//  DataManager.swift
//  List
//
//  Created by Anton Cherkasov on 01.02.2026.
//

import Foundation
import SwiftUI
import SwiftData

final class DataManager {

}

// MARK: - Public Interface
extension DataManager {

	@discardableResult
	static func addItem(with text: String, to context: ModelContext, all: [Item]) -> PersistentIdentifier {
		let new = Item(text: text)
		for (index, item) in all.enumerated() {
			item.index = index + 1
		}
		context.insert(new)
		return new.id
	}

	static func deleteItems(_ ids: Set<PersistentIdentifier>, in context: ModelContext, all: [Item]) {
		let filtered = all.filter {
			ids.contains($0.id)
		}
		try? context.transaction {
			for item in filtered {
				context.delete(item)
			}
		}
	}

	static func deleteItem(_ item: Item, in context: ModelContext) {
		context.delete(item)
	}

	static func moveItems(_ indices: IndexSet, to target: Int, in context: ModelContext, all: [Item]) {
		var modificated = all
		modificated.move(fromOffsets: indices, toOffset: target)
		try? context.transaction {
			for (index, item) in modificated.enumerated() {
				item.index = index
			}
		}
	}

	static func updateItem(_ item: Item, with newText: String, in context: ModelContext) {
		guard !newText.isEmpty else {
			context.delete(item)
			return
		}
		item.text = newText
	}
}
