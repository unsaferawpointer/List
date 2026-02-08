//
//  ContentLocalization + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

#if os(macOS)
import Foundation

struct ContentLocalization {

	static var itemCellPlaceholder: String {
		String(localized: "item-cell-placeholder", table: "ContentLocalizable + macOS")
	}

	static var defaultItemText: String {
		String(localized: "item-default-text", table: "ContentLocalizable + macOS")
	}

	struct Menu {
		static var completed: String {
			String(localized: "menu.item.completed", table: "ContentLocalizable + macOS")
		}
		static var tags: String {
			String(localized: "menu.item.tags", table: "ContentLocalizable + macOS")
		}
		static var delete: String {
			String(localized: "menu.item.delete", table: "ContentLocalizable + macOS")
		}
	}

	struct Toolbar {
		static var add: String {
			String(localized: "toolbar.item.add", table: "ContentLocalizable + macOS")
		}
	}
}
#endif
