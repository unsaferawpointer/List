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
		case let .include(tags, _):
			return tags.map(\.title).joined(separator: ", ")
		case let .exclude(tags, _):
			return localizationService.navigationTitle(for: tags.map(\.title))
		default:
			return localizationService.navigationTitleDefault
		}
	}

	func makeSubtitle(filter: Filter, tags: [Tag], itemsCount: Int) -> String {

		let suffix = localizationService.navigationSubtitle(for: itemsCount)

		let condition = condition(filter: filter, tags: tags)

		switch condition {
		case .all, .completed, .incomplete:
			return suffix
		case .include, .exclude, .mixed:
			return switch filter.completionState {
			case .include:
				[localizationService.navigationTitleCompleted, suffix].joined(separator: ": ")
			case .exlude:
				[localizationService.navigationTitleIncomplete, suffix].joined(separator: ": ")
			case .any:
				suffix
			}
		}
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
		case (1..., 0, _):
			return .include(tags: includedTags, completion: filter.completionState)
		case (0, 1..., _):
			return .exclude(tags: excludedTags, completion: filter.completionState)
		default:
			return .mixed(
				include: includedTags,
				exclude: excludedTags,
				completion: filter.completionState
			)
		}
	}
}

// MARK: - Nested Data Structs
private extension TextFactory {

	enum Condition {
		case all
		case completed
		case incomplete
		case include(tags: [Tag], completion: Filter.MatchType)
		case exclude(tags: [Tag], completion: Filter.MatchType)
		case mixed(include: [Tag], exclude: [Tag], completion: Filter.MatchType)
	}
}
