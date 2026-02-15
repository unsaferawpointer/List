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

	static func moveItems(_ ids: Set<PersistentIdentifier>, to target: Destination<PersistentIdentifier>, in context: ModelContext, all: [Item]) {
		guard let targetIndex = all.firstIndex(where: { $0.id == target.id }) else {
			return
		}

		var cache: [PersistentIdentifier: Int] = [:]
		for (index, item) in all.enumerated() {
			cache[item.id] = index
		}

		var indices = IndexSet()
		ids.forEach {
			guard let index = cache[$0] else {
				return
			}
			indices.insert(index)
		}

		switch target {
		case .before:
			moveItems(indices, to: targetIndex, in: context, all: all)
		case .after:
			moveItems(indices, to: targetIndex + 1, in: context, all: all)
		}
	}

	static func updateItem(_ item: Item, with newText: String, in context: ModelContext) {
		guard !newText.isEmpty else {
			context.delete(item)
			return
		}
		item.text = newText
	}

	// MARK: - Tags

	@discardableResult
	static func addTag(with title: String, to context: ModelContext, all: [Tag]) -> PersistentIdentifier {
		let new = Tag(title: title)
		for (index, tag) in all.enumerated() {
			tag.index = index + 1
		}
		context.insert(new)
		return new.id
	}

	static func moveTags(_ indices: IndexSet, to target: Int, in context: ModelContext, all: [Tag]) {
		var modificated = all
		modificated.move(fromOffsets: indices, toOffset: target)
		try? context.transaction {
			for (index, item) in modificated.enumerated() {
				item.index = index
			}
		}
	}

	static func deleteTags(_ ids: Set<PersistentIdentifier>, in context: ModelContext, all: [Tag]) {
		let filtered = all.filter {
			ids.contains($0.id)
		}
		try? context.transaction {
			for item in filtered {
				context.delete(item)
			}
		}
	}
}
