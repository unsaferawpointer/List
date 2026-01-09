//
//  ContentModel.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import Foundation
import SwiftData

final class ContentModel {

}

extension ContentModel {

	func navigationTitle(isEditMode: Bool, selection: Set<PersistentIdentifier>) -> String {
		isEditMode && !selection.isEmpty
			? String(localized: "\(selection.count) Selected", table: "ContentLocalizable")
			: String(localized: "All Items", table: "ContentLocalizable")
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
