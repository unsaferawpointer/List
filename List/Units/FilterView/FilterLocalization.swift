//
//  FilterLocalization.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import Foundation

struct FilterLocalization {

	struct NavigationBar {
		static var title: String {
			String(localized: "title", table: "FilterLocalizable")
		}
	}

	struct Toolbar {
		static var done: String {
			String(localized: "done", table: "FilterLocalizable")
		}
	}

	struct Footer {
		static var clear: String {
			String(localized: "clear", table: "FilterLocalizable")
		}
	}

	struct Filter {

		static var completed: String {
			String(localized: "view.completed", table: "FilterLocalizable")
		}

		static var tagsSection: String {
			String(localized: "section.tags", table: "FilterLocalizable")
		}
	}
}
