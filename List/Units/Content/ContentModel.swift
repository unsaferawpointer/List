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

	func navigationTitle(
		isEditMode: Bool,
		selection: Set<PersistentIdentifier>,
		tags: [Tag],
		selected: Set<UUID>
	) -> String {
		let isFiltering = !tags.isEmpty && !selected.isEmpty
		guard !isFiltering else {
			return String(localized: "Filtered by tags", table: "ContentLocalizable")
		}
		return isEditMode && !selection.isEmpty
			? String(localized: "\(selection.count) Selected", table: "ContentLocalizable")
			: String(localized: "All Items", table: "ContentLocalizable")
	}

	func navigationSubtitle(
		isEditMode: Bool,
		selection: Set<PersistentIdentifier>,
		tags: [Tag],
		selected: Set<UUID>
	) -> String? {
		let isFiltering = !tags.isEmpty && !selected.isEmpty
		guard isFiltering else {
			return nil
		}
		return tags.filter {
			selected.contains($0.uuid)
		}
		.map(\.title)
		.joined(separator: ", ")
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
