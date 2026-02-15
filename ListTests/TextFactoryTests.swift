//
//  ListTests.swift
//  ListTests
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import Foundation
import Testing
@testable import List

@MainActor
@Suite("TextFactory")
struct TextFactoryTests {

	@Test func makeTitle_emptyFilter_returnsEmptyFilterTitle() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let title = factory.makeTitle(filter: .init(), tags: [])

		#expect(title == localization.stubs.emptyFilterTitle)
	}

	@Test func makeTitle_includeCompletion_returnsCompletedTitle() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let title = factory.makeTitle(filter: .init(completionState: .include), tags: [])

		#expect(title == localization.stubs.navigationTitleCompleted)
	}

	@Test func makeTitle_excludeCompletion_returnsIncompleteTitle() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let title = factory.makeTitle(filter: .init(completionState: .exlude), tags: [])

		#expect(title == localization.stubs.navigationTitleIncomplete)
	}

	@Test func makeTitle_singleIncludedTag_returnsTagTitle() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let expectedTitle: String = .random

		let uuid = UUID()
		let tag = Tag(uuid: uuid, title: expectedTitle)

		let title = factory.makeTitle(
			filter: .init(includedTag: [uuid]),
			tags: [tag]
		)

		#expect(title == expectedTitle)
	}

	@Test func makeTitle_otherConditions_returnsDefaultTitle() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let firstUUID = UUID()
		let secondUUID = UUID()
		let tags = [
			Tag(uuid: firstUUID, title: .random),
			Tag(uuid: secondUUID, title: .random)
		]

		let title = factory.makeTitle(
			filter: .init(includedTag: [firstUUID, secondUUID]),
			tags: tags
		)

		#expect(title == localization.stubs.navigationTitleDefault)
	}

	@Test func makeSubtitle_forwardsItemsCountToLocalization() async throws {
		let localization = LocalizationMock()
		let factory = TextFactory(localizationService: localization)

		let subtitle = factory.makeSubtitle(filter: .init(), tags: [], itemsCount: 42)


		#expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
		guard case let .navigationSubtitle(itemsCount) = localization.invocations.first else {
			return
		}
		#expect(itemsCount == 42)
	}
}

// MARK: - Stubs

fileprivate final class LocalizationMock {
	var stubs = Stubs()
	private(set) var invocations: [Invocation] = []
}

// MARK: - TextFactoryLocalizable
extension LocalizationMock: TextFactoryLocalizable {

	var emptyFilterTitle: String {
		stubs.emptyFilterTitle
	}
	
	var navigationTitleCompleted: String {
		stubs.navigationTitleCompleted
	}
	
	var navigationTitleIncomplete: String {
		stubs.navigationTitleIncomplete
	}
	
	var navigationTitleDefault: String {
		stubs.navigationTitleDefault
	}
	
	func navigationSubtitle(for itemsCount: Int) -> String {
		invocations.append(.navigationSubtitle(itemsCount: itemsCount))
		return stubs.navigationSubtitleForItemsCount
	}
}

// MARK: - Nested Data Structs
extension LocalizationMock {

	enum Invocation {
		case navigationSubtitle(itemsCount: Int)
	}

	struct Stubs {
		var emptyFilterTitle: String = .random
		var navigationTitleCompleted: String = .random
		var navigationTitleIncomplete: String = .random
		var navigationTitleDefault: String = .random
		var navigationSubtitleForItemsCount: String = .random
	}
}
