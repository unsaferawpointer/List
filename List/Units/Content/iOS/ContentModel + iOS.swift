//
//  ContentModel.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

#if os(iOS)
import Foundation
import SwiftData

@Observable
final class ContentModel {

	var isItemEditorPresented: Bool = false

	var presentedItem: Item?

	var presentedItemForTagsPicker: Item?

	var isTagPickerPresented: Bool = false

	var selection: Set<PersistentIdentifier> = []

	let textFactory = TextFactory()
}

extension ContentModel {

	func itemEditorTitle(isNew: Bool) -> String {
		isNew
			? String(localized: "New Item", table: "ContentLocalizable + iOS")
			: String(localized: "Edit Item", table: "ContentLocalizable + iOS")
	}

	func navigationTitle(isEditMode: Bool, tags: [Tag], filter: Filter) -> String {
		guard !isEditMode else {
			return ContentLocalization.NavigationBar.editModeTitle(selectionCount: selection.count)
		}
		return textFactory.makeTitle(filter: filter, tags: tags)
	}

	func navigationSubtitle(isEditMode: Bool, tags: [Tag], items: [Item], filter: Filter) -> String {
		guard !isEditMode else {
			return ContentLocalization.NavigationBar.editModeSubtitle(count: items.count)
		}
		return textFactory.makeSubtitle(filter: filter, tags: tags, itemsCount: items.count)
	}
}

// MARK: - Public Interface
extension ContentModel {

	func addItem(text: String, to modelContext: ModelContext, allItems: [Item]) {
		let newItem = Item(timestamp: Date(), text: text)
		for item in allItems {
			item.index += 1
		}
		modelContext.insert(newItem)
	}

	func selectAll(items: [Item]) {
		for item in items {
			selection.insert(item.id)
		}
	}

	func editItem(_ item: Item) {
		presentedItem = item
	}

	func showTagsPicker(for item: Item) {
		presentedItemForTagsPicker = item
	}
}

extension ContentModel {

	func shouldDisplayEditButton(for items: [Item]) -> Bool {
		return !items.isEmpty
	}
}
#endif
