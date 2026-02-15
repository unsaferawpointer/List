//
//  TextFactory.swift
//  List
//
//  Created by Anton Cherkasov on 07.02.2026.
//

import Foundation

final class TextFactory {

	let localizationService: TextFactoryLocalizable

	// MARK: - Initialization

	init(localizationService: TextFactoryLocalizable = TextFactory.LocalizationFactory()) {
		self.localizationService = localizationService
	}
}

extension TextFactory {

	func makeTitle(filter: Filter, tags: [Tag]) -> String {

		let condition = condition(filter: filter, tags: tags)

		switch condition {
		case .all:
			return localizationService.emptyFilterTitle
		case .completed:
			return localizationService.navigationTitleCompleted
		case .incomplete:
			return localizationService.navigationTitleIncomplete
		case let .singleTag(tag):
			return tag.title
		default:
			return localizationService.navigationTitleDefault
		}
	}

	func makeSubtitle(filter: Filter, tags: [Tag], itemsCount: Int) -> String {
		return localizationService.navigationSubtitle(for: itemsCount)
	}
}

// MARK: - Helpers
private extension TextFactory {

	func condition(filter: Filter, tags: [Tag]) -> Condition {

		guard !filter.isEmpty else {
			return .all
		}

		let excludedTags = tags.filter {
			filter.excludedTag.contains($0.uuid)
		}
		let includedTags = tags.filter {
			filter.includedTag.contains($0.uuid)
		}

		switch (includedTags.count, excludedTags.count, filter.completionState) {
		case (0, 0, .any):
			return .all
		case (0, 0, .include):
			return .completed
		case (0, 0, .exlude):
			return .incomplete
		case (1, 0, .any):
			guard let tag = includedTags.first else {
				fatalError()
			}
			return .singleTag(tag)
		default:
			return .other
		}
	}
}

// MARK: - Nested Data Structs
private extension TextFactory {

	enum Condition {
		case all
		case completed
		case incomplete
		case singleTag(_ tag: Tag)
		case other
	}
}
