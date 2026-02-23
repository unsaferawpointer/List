//
//  ContentLocalization + iOS.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

#if os(iOS)
import Foundation

struct ContentLocalization {

	struct Menu {
		static var undo: String {
			String(localized: "menu.item.undo", table: "ContentLocalizable + iOS")
		}
		static var redo: String {
			String(localized: "menu.item.redo", table: "ContentLocalizable + iOS")
		}
		static var edit: String {
			String(localized: "menu.item.edit", table: "ContentLocalizable + iOS")
		}
		static var completed: String {
			String(localized: "menu.item.completed", table: "ContentLocalizable + iOS")
		}
		static var tags: String {
			String(localized: "menu.item.tags", table: "ContentLocalizable + iOS")
		}
		static var delete: String {
			String(localized: "menu.item.delete", table: "ContentLocalizable + iOS")
		}
	}

	struct Toolbar {
		static var main: String {
			String(localized: "toolbar.item.main", table: "ContentLocalizable + iOS")
		}
		static var selectAll: String {
			String(localized: "toolbar.item.selectAll", table: "ContentLocalizable + iOS")
		}
		static var add: String {
			String(localized: "toolbar.item.add", table: "ContentLocalizable + iOS")
		}
	}

	struct ContentUnavailable {
		static var message: String {
			String(localized: "unavailable-content-message", table: "ContentLocalizable + iOS")
		}
		static var title: String {
			String(localized: "unavailable-content-title", table: "ContentLocalizable + iOS")
		}
	}

	struct StrictFilter {
		static var text: String {
			String(localized: "unavailable.content.strict.filter.text", table: "ContentLocalizable + macOS")
		}
		static var message: String {
			String(localized: "unavailable.content.strict.filter.message", table: "ContentLocalizable + macOS")
		}
	}

	struct NavigationBar {
		static func editModeTitle(selectionCount: Int) -> String {
			String(localized: "navigation.bar.edit.mode.title count=\(selectionCount)", table: "ContentLocalizable + iOS")
		}
		static func editModeSubtitle(count: Int) -> String {
			String(localized: "navigation.bar.edit.mode.subtitle count=\(count)", table: "ContentLocalizable + iOS")
		}
	}
}
#endif
