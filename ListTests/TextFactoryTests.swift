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

    @Test func makeTitle_whenFilterIsEmpty_returnsEmptyTitle() async throws {
        let (factory, localization) = makeSubject()

        let title = factory.makeTitle(filter: .init(), tags: [])

        #expect(title == localization.stubs.emptyFilterTitle)
    }

    @Test func makeTitle_whenCompletionIncluded_returnsCompletedTitle() async throws {
        let (factory, localization) = makeSubject()

        let title = factory.makeTitle(filter: .init(completionState: .include), tags: [])

        #expect(title == localization.stubs.navigationTitleCompleted)
    }

    @Test func makeTitle_whenCompletionExcluded_returnsIncompleteTitle() async throws {
        let (factory, localization) = makeSubject()

        let title = factory.makeTitle(filter: .init(completionState: .exlude), tags: [])

        #expect(title == localization.stubs.navigationTitleIncomplete)
    }

    @Test func makeTitle_whenSingleIncludedTag_returnsTagTitle() async throws {
        let (factory, _) = makeSubject()

        let expectedTitle: String = .random
        let (tagID, tag) = makeTag(title: expectedTitle)

        let title = factory.makeTitle(
            filter: .init(includedTag: [tagID]),
            tags: [tag]
        )

        #expect(title == expectedTitle)
    }

    @Test func makeTitle_whenMultipleIncludedTags_returnsJoinedTitles() async throws {
        let (factory, _) = makeSubject()

        let firstTitle: String = .random
        let secondTitle: String = .random
        let firstID = UUID()
        let secondID = UUID()
        let tags = [
            AppTag(uuid: firstID, title: firstTitle),
            AppTag(uuid: secondID, title: secondTitle)
        ]

        let title = factory.makeTitle(
            filter: .init(includedTag: [firstID, secondID]),
            tags: tags
        )

        #expect(title == [firstTitle, secondTitle].joined(separator: ", "))
    }

    @Test func makeTitle_whenExcludedTags_returnsExcludedTitle() async throws {
        let (factory, localization) = makeSubject()

        let firstTitle: String = .random
        let secondTitle: String = .random
        let firstID = UUID()
        let secondID = UUID()
        let tags = [
            AppTag(uuid: firstID, title: firstTitle),
            AppTag(uuid: secondID, title: secondTitle)
        ]

        let title = factory.makeTitle(
            filter: .init(excludedTag: [firstID, secondID]),
            tags: tags
        )

        #expect(title == localization.stubs.navigationTitleForExcludedList)
        guard case let .navigationTitle(excludedList) = localization.invocations.first else {
            return
        }
        #expect(excludedList == [firstTitle, secondTitle])
    }

    @Test func makeTitle_whenMixedTags_returnsDefaultTitle() async throws {
        let (factory, localization) = makeSubject()

        let includedID = UUID()
        let excludedID = UUID()
        let tags = [
            AppTag(uuid: includedID, title: .random),
            AppTag(uuid: excludedID, title: .random)
        ]

        let title = factory.makeTitle(
            filter: .init(includedTag: [includedID], excludedTag: [excludedID]),
            tags: tags
        )

        #expect(title == localization.stubs.navigationTitleDefault)
    }

    @Test func makeSubtitle_forwardsItemsCountToLocalization() async throws {
        let (factory, localization) = makeSubject()

        let subtitle = factory.makeSubtitle(filter: .init(), tags: [], itemsCount: 42)

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
        guard case let .navigationSubtitle(itemsCount) = localization.invocations.first else {
            return
        }
        #expect(itemsCount == 42)
    }

    @Test func makeSubtitle_whenAllFilter_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let subtitle = factory.makeSubtitle(filter: .init(), tags: [], itemsCount: 1)

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenCompletionIncluded_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let subtitle = factory.makeSubtitle(filter: .init(completionState: .include), tags: [], itemsCount: 1)

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenCompletionExcluded_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let subtitle = factory.makeSubtitle(filter: .init(completionState: .exlude), tags: [], itemsCount: 1)

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenSingleTagAndInclude_addsCompletedPrefix() async throws {
        let (factory, localization) = makeSubject()

        let (tagID, tag) = makeTag()

        let subtitle = factory.makeSubtitle(
            filter: .init(completionState: .include, includedTag: [tagID]),
            tags: [tag],
            itemsCount: 1
        )

        #expect(subtitle == expectedSubtitle(prefix: localization.stubs.navigationTitleCompleted, localization: localization))
    }

    @Test func makeSubtitle_whenSingleTagAndExclude_addsIncompletePrefix() async throws {
        let (factory, localization) = makeSubject()

        let (tagID, tag) = makeTag()

        let subtitle = factory.makeSubtitle(
            filter: .init(completionState: .exlude, includedTag: [tagID]),
            tags: [tag],
            itemsCount: 1
        )

        #expect(subtitle == expectedSubtitle(prefix: localization.stubs.navigationTitleIncomplete, localization: localization))
    }

    @Test func makeSubtitle_whenSingleTagAndAny_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let (tagID, tag) = makeTag()

        let subtitle = factory.makeSubtitle(
            filter: .init(includedTag: [tagID]),
            tags: [tag],
            itemsCount: 1
        )

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenExcludedTagsAndAny_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let firstID = UUID()
        let secondID = UUID()
        let tags = [
            AppTag(uuid: firstID, title: .random),
            AppTag(uuid: secondID, title: .random)
        ]

        let subtitle = factory.makeSubtitle(
            filter: .init(excludedTag: [firstID, secondID]),
            tags: tags,
            itemsCount: 1
        )

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenExcludedTagsAndInclude_addsCompletedPrefix() async throws {
        let (factory, localization) = makeSubject()

        let firstID = UUID()
        let secondID = UUID()
        let tags = [
            AppTag(uuid: firstID, title: .random),
            AppTag(uuid: secondID, title: .random)
        ]

        let subtitle = factory.makeSubtitle(
            filter: .init(completionState: .include, excludedTag: [firstID, secondID]),
            tags: tags,
            itemsCount: 1
        )

        #expect(subtitle == expectedSubtitle(prefix: localization.stubs.navigationTitleCompleted, localization: localization))
    }

    @Test func makeSubtitle_whenMixedTagsAndAny_returnsSuffix() async throws {
        let (factory, localization) = makeSubject()

        let includedID = UUID()
        let excludedID = UUID()
        let tags = [
            AppTag(uuid: includedID, title: .random),
            AppTag(uuid: excludedID, title: .random)
        ]

        let subtitle = factory.makeSubtitle(
            filter: .init(includedTag: [includedID], excludedTag: [excludedID]),
            tags: tags,
            itemsCount: 1
        )

        #expect(subtitle == localization.stubs.navigationSubtitleForItemsCount)
    }

    @Test func makeSubtitle_whenOtherConditionsAndInclude_addsCompletedPrefix() async throws {
        let (factory, localization) = makeSubject()

        let firstID = UUID()
        let secondID = UUID()
        let tags = [
            AppTag(uuid: firstID, title: .random),
            AppTag(uuid: secondID, title: .random)
        ]

        let subtitle = factory.makeSubtitle(
            filter: .init(completionState: .include, includedTag: [firstID, secondID]),
            tags: tags,
            itemsCount: 1
        )

        #expect(subtitle == expectedSubtitle(prefix: localization.stubs.navigationTitleCompleted, localization: localization))
    }
}

// MARK: - Helpers
private extension TextFactoryTests {

    func makeSubject() -> (TextFactory, LocalizationMock) {
        let localization = LocalizationMock()
        return (TextFactory(localizationService: localization), localization)
    }

    func makeTag(title: String = .random) -> (UUID, AppTag) {
        let id = UUID()
        return (id, AppTag(uuid: id, title: title))
    }

    func expectedSubtitle(prefix: String, localization: LocalizationMock) -> String {
        [prefix, localization.stubs.navigationSubtitleForItemsCount].joined(separator: ": ")
    }
}

private typealias AppTag = List.Tag

// MARK: - Stubs
@MainActor
fileprivate final class LocalizationMock {
    var stubs = Stubs()
    private(set) var invocations: [Invocation] = []
}

// MARK: - TextFactoryLocalizable
extension LocalizationMock: List.TextFactoryLocalizable {

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

    func navigationTitle(for excludedList: [String]) -> String {
        invocations.append(.navigationTitle(excludedList: excludedList))
        return stubs.navigationTitleForExcludedList
    }
}

// MARK: - Nested Data Structs
extension LocalizationMock {

    enum Invocation {
        case navigationSubtitle(itemsCount: Int)
        case navigationTitle(excludedList: [String])
    }

    struct Stubs {
        var emptyFilterTitle: String = .random
        var navigationTitleCompleted: String = .random
        var navigationTitleIncomplete: String = .random
        var navigationTitleDefault: String = .random
        var navigationSubtitleForItemsCount: String = .random
        var navigationTitleForExcludedList: String = .random
    }
}
