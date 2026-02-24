//
//  ContentModel + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 24.02.2026.
//

#if os(macOS)
import Foundation
import SwiftData

@Observable
final class ContentModel {

	var selection: Set<PersistentIdentifier> = []

	var scrollPosition: PersistentIdentifier?

	let textFactory: TextFactory

	// MARK: - Initialization

	init(textFactory: TextFactory = TextFactory()) {
		self.textFactory = textFactory
	}
}

// MARK: - Public Interface
extension ContentModel {

	func updateItem(_ item: Item, with newText: String, in context: ModelContext) {
		DataManager.updateItem(item, with: newText, in: context)
	}

	func deleteItems(in context: ModelContext, items: [Item]) {
		DataManager.deleteItems(selection, in: context, all: items)
		selection.removeAll()
	}

	func deleteItems(ids: Set<PersistentIdentifier>, in context: ModelContext, items: [Item]) {
		DataManager.deleteItems(ids, in: context, all: items)
		selection.removeAll()
	}

	func moveItems(
		_ ids: Set<PersistentIdentifier>,
		to target: Destination<PersistentIdentifier>,
		in context: ModelContext, all: [Item]
	) {
		DataManager.moveItems(ids, to: target, in: context, all: all)
	}
}

import SwiftUI

extension ContentModel {

	func title(for filter: Filter, tags: [Tag]) -> String {
		textFactory.makeTitle(filter: filter, tags: tags)
	}

	func subtitle(for filter: Filter, tags: [Tag], itemsCount: Int) -> String {
		textFactory.makeSubtitle(filter: filter, tags: tags, itemsCount: itemsCount)
	}
}

extension ContentModel {

	func filter(from filterData: Binding<Data?>, tags: [Tag]) -> Binding<Filter> {
		Binding {
			guard
				let data = filterData.wrappedValue,
				let result = try? JSONDecoder().decode(Filter.self, from: data)
			else {
				return Filter()
			}
			return Filter(
				completionState: result.completionState,
				includedTag: result.includedTag.intersection(tags.map(\.uuid)),
				excludedTag: result.excludedTag.intersection(tags.map(\.uuid))
			)
		} set: { newValue in
			guard let data = try? JSONEncoder().encode(newValue) else {
				filterData.wrappedValue = nil
				return
			}
			filterData.wrappedValue = data
		}
	}

	func completionSources(for items: [Item]) -> [Binding<Bool>] {
		return items.filter { item in
			selection.contains(item.id)
		}.map { item in
			Binding {
				item.isCompleted
			} set: { newValue in
				item.isCompleted = newValue
			}
		}
	}
}

extension ContentModel {

	var actionsIsEnabled: Bool {
		!selection.isEmpty
	}
}
#endif
