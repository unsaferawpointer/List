//
//  TextFactory + Localization.swift
//  List
//
//  Created by Anton Cherkasov on 14.02.2026.
//

import Foundation

protocol TextFactoryLocalizable {

	var emptyFilterTitle: String { get }

	var navigationTitleCompleted: String { get }

	var navigationTitleIncomplete: String { get }

	var navigationTitleDefault: String { get }

	func navigationSubtitle(for itemsCount: Int) -> String
}

extension TextFactory {

	final class LocalizationFactory { }
}

// MARK: - TextFactoryLocalizable
extension TextFactory.LocalizationFactory: TextFactoryLocalizable {

	var emptyFilterTitle: String {
		String(localized: "empty-filter-title", table: "CommonLocalizable")
	}

	var navigationTitleCompleted: String {
		String(localized: "navigation.title.completed", table: "CommonLocalizable")
	}

	var navigationTitleIncomplete: String {
		String(localized: "navigation.title.incomplete", table: "CommonLocalizable")
	}

	var navigationTitleDefault: String {
		String(localized: "not-empty-filter-title", table: "CommonLocalizable")
	}

	func navigationSubtitle(for itemsCount: Int) -> String {
		String(localized: "items.count.subtitle \(itemsCount)", table: "CommonLocalizable")
	}
}
