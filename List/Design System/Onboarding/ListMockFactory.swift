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
			.init(title: "Work", iconName: .mail, state: .active),
			.init(title: "Travel", iconName: .sparkles, state: .normal),
			.init(title: "Ideas", iconName: .bolt, state: .active),
			.init(title: "Sport", iconName: .heart, state: .normal),
			.init(title: "Archive", iconName: .archivebox, state: .excluded)
		]
	}

	static func rows(count: Int, focusedRow: Int?) -> [ListMock.RowMock] {
		let base: [ListMock.RowMock] = [
			.init(title: "Buy groceries", subtitle: "Milk, bread, vegetables"),
			.init(title: "Call mom", subtitle: "See how she’s doing"),
			.init(title: "Work out", subtitle: "20 minutes at home"),
			.init(title: "Pay bills", subtitle: "Internet and phone"),
			.init(title: "Take out the trash", subtitle: "Before you head out"),
			.init(title: "Read 20 pages", subtitle: "Before bed")
		]

		let desiredCount = max(count, 0)
		let expanded: [ListMock.RowMock]
		if desiredCount <= base.count {
			expanded = Array(base.prefix(desiredCount))
		} else {
			expanded = base + (base.count..<desiredCount).map { index in
				ListMock.RowMock(title: "Task \(index + 1)", subtitle: "Everyday task")
			}
		}

		guard let focusedRow, expanded.indices.contains(focusedRow) else {
			return expanded
		}

		return expanded.enumerated().map { index, row in
			if index == focusedRow {
				return ListMock.RowMock(id: row.id, title: row.title, subtitle: row.subtitle, isShimmering: false)
			}
			return row
		}
	}
}
