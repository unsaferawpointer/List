//
//  ListMockFactory.swift
//  List
//
//  Created by Anton Cherkasov on 09.02.2026.
//

import Foundation

enum ListMockFactory {

	static func tags() -> [ListMock.TagMock] {
		return [
			.init(title: OnboardingTextFactory.Mock.Tags.work, iconName: .mail, state: .active),
			.init(title: OnboardingTextFactory.Mock.Tags.travel, iconName: .sparkles, state: .normal),
			.init(title: OnboardingTextFactory.Mock.Tags.ideas, iconName: .bolt, state: .active),
			.init(title: OnboardingTextFactory.Mock.Tags.sport, iconName: .heart, state: .normal),
			.init(title: OnboardingTextFactory.Mock.Tags.archive, iconName: .archivebox, state: .excluded)
		]
	}

	static func cleanRows() -> [ListMock.RowMock] {
		return [
			.init(title: OnboardingTextFactory.Mock.Tasks.planWeekendTrip, subtitle: "", isShimmering: false),
			.init(title: OnboardingTextFactory.Mock.Tasks.buyGroceries, subtitle: "", isShimmering: false),
			.init(title: OnboardingTextFactory.Mock.Tasks.callMom, subtitle: "", isShimmering: false),
			.init(title: OnboardingTextFactory.Mock.Tasks.read20Pages, subtitle: "", isShimmering: false)
		]
	}

	static func rows(count: Int) -> [ListMock.RowMock] {
		let base: [ListMock.RowMock] = [
			.init(title: OnboardingTextFactory.Mock.Tasks.buyGroceries, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.work, OnboardingTextFactory.Mock.Tags.ideas])),
			.init(title: OnboardingTextFactory.Mock.Tasks.callMom, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.travel])),
			.init(title: OnboardingTextFactory.Mock.Tasks.workOut, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.sport])),
			.init(title: OnboardingTextFactory.Mock.Tasks.payBills, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.archive])),
			.init(title: OnboardingTextFactory.Mock.Tasks.takeOutTrash, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.work])),
			.init(title: OnboardingTextFactory.Mock.Tasks.read20Pages, subtitle: tagsSubtitle([OnboardingTextFactory.Mock.Tags.ideas]))
		]

		let desiredCount = max(count, 0)
		let expanded: [ListMock.RowMock]
		if desiredCount <= base.count {
			expanded = Array(base.prefix(desiredCount))
		} else {
			expanded = base + (base.count..<desiredCount).map { index in
				ListMock.RowMock(title: OnboardingTextFactory.Mock.Tasks.generic(number: index + 1), subtitle: "")
			}
		}
		return expanded
	}
}
// MARK: - Helpers
private extension ListMockFactory {

	static func tagsSubtitle(_ tags: [String]) -> String {
		tags.joined(separator: " | ")
	}
}

