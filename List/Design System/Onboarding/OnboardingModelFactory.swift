//
//  OnboardingModelFactory.swift
//  List
//
//  Created by Anton Cherkasov on 10.02.2026.
//

import Foundation

enum OnboardingModelFactory {

	static func makeModel(focusedRow: Int = 2) -> OnboardingView.Model {
		.init(
			steps: [
				.init(
					title: OnboardingTextFactory.Pages.welcomeTitle,
					subtitle: OnboardingTextFactory.Pages.welcomeSubtitle,
					listMock: .init(showTags: false, rows: ListMockFactory.cleanRows())
				),
				.init(
					title: OnboardingTextFactory.Pages.tagsTitle,
					subtitle: OnboardingTextFactory.Pages.tagsSubtitle,
					listMock: .init(showTags: true)
				),
				.init(
					title: OnboardingTextFactory.Pages.focusTitle,
					subtitle: OnboardingTextFactory.Pages.focusSubtitle,
					listMock: .init(
						showTags: false,
						rows: makeRows(count: 6, focusedRow: focusedRow)
					)
				)
			]
		)
	}
}

// MARK: - Helpers
private extension OnboardingModelFactory {

	static func makeRows(count: Int, focusedRow: Int) -> [ListMock.RowMock] {
		ListMockFactory.rows(count: count).enumerated().map { index, row in
			guard index == focusedRow else {
				return row
			}
			return ListMock.RowMock(id: row.id, title: row.title, subtitle: row.subtitle, isShimmering: false)
		}
	}
}
