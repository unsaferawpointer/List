//
//  ContentModel.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import Foundation
import SwiftData

@Observable
final class ContentModel {

	var isItemEditorPresented: Bool = false

	var presentedItem: Item?

	var presentedItemForTagsPicker: Item?

	var isTagPickerPresented: Bool = false

	var selection: Set<PersistentIdentifier> = []
}

// MARK: - Context Menu Localization
extension ContentModel {

	func menuItemTitle(id: ElementIdentifier) -> String {
		switch id {
		case .edit:
			String(localized: "Edit...", table: "ContentLocalizable")
		case .delete:
			String(localized: "Delete", table: "ContentLocalizable")
		case .undo:
			String(localized: "Undo", table: "ContentLocalizable")
		case .redo:
			String(localized: "Redo", table: "ContentLocalizable")
		case .tags:
			String(localized: "Tags...", table: "ContentLocalizable")
		case .status:
			String(localized: "Completed", table: "ContentLocalizable")
		}
	}
}

extension ContentModel {

	func itemEditorTitle(isNew: Bool) -> String {
		isNew
			? String(localized: "New Item", table: "ContentLocalizable")
			: String(localized: "Edit Item", table: "ContentLocalizable")
	}

	func contentUnavailableMessage() -> String {
		String(localized: "Tap \"+\" to add your first task.", table: "ContentLocalizable")
	}

	func contentUnavailableTitle() -> String {
		String(localized: "No Tasks", table: "ContentLocalizable")
	}

	func navigationTitle(isEditMode: Bool, tags: [Tag], filter: Filter) -> String {
		guard !isEditMode else {
			return String(localized: "\(selection.count) Selected", table: "ContentLocalizable")
		}
		return TextFactory.makeTitle(filter: filter, tags: tags)
	}

	func navigationSubtitle(isEditMode: Bool, tags: [Tag], items: [Item], filter: Filter) -> String {
		guard !isEditMode else {
			return "\(items.count) Items"
		}
		return TextFactory.makeSubtitle(filter: filter, tags: tags, itemsCount: items.count)
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

	func editItem(_ item: Item) {
		presentedItem = item
	}

	func showTagsPicker(for item: Item) {
		presentedItemForTagsPicker = item
	}
}

extension ContentModel {

	func shouldContentUnavailableView(for items: [Item]) -> Bool {
		return items.isEmpty
	}

	func shouldDisplayEditButton(for items: [Item]) -> Bool {
		return !items.isEmpty
	}
}
