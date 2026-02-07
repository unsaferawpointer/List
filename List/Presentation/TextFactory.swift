//
//  TextFactory.swift
//  List
//
//  Created by Anton Cherkasov on 07.02.2026.
//

import Foundation

final class TextFactory { }

extension TextFactory {

	static func makeTitle(filter: Filter, tags: [Tag]) -> String {

		let excludedTags = tags.filter {
			filter.excludedTag.contains($0.uuid)
		}
		let includedTags = tags.filter {
			filter.includedTag.contains($0.uuid)
		}
		return switch (includedTags.isEmpty, excludedTags.isEmpty) {
		case (true, true):
			String(localized: "empty-filter-title", table: "CommonLocalizable")
		default:
			String(localized: "not-empty-filter-title", table: "CommonLocalizable")
		}
	}

	static func makeSubtitle(filter: Filter, tags: [Tag], itemsCount: Int) -> String {

		let excludedTags = tags.filter {
			filter.excludedTag.contains($0.uuid) && $0.isHidden == false
		}
		let includedTags = tags.filter {
			filter.includedTag.contains($0.uuid) && $0.isHidden == false
		}

		let totalCount = includedTags.count + excludedTags.count
		let overLimit = totalCount > 4

		let includedTitles = includedTags.map(\.title).joined(separator: ", ")
		let excludedTitles = excludedTags.map(\.title).joined(separator: ", ")

		return switch (includedTags.isEmpty, excludedTags.isEmpty) {
		case (true, true):
			String(localized: "items.count.subtitle \(itemsCount)", table: "CommonLocalizable")
		case (true, false):
			overLimit
				? String(localized: "items.excluded.count.subtitle \(excludedTags.count)", table: "CommonLocalizable")
				: String(localized: "items.excluded.subtitle \(excludedTitles)", table: "CommonLocalizable")
		case (false, true):
			overLimit
				? String(localized: "items.included.count.subtitle \(includedTags.count)", table: "CommonLocalizable")
				: String(localized: "items.included.subtitle \(includedTitles)", table: "CommonLocalizable")
		case (false, false):
			overLimit
				? String(localized: "items.included.excluded.count.subtitle \(includedTags.count) \(excludedTags.count)", table: "CommonLocalizable")
				: String(localized: "items.included.excluded.subtitle \(includedTitles) \(excludedTitles)", table: "CommonLocalizable")
		}
	}
}
