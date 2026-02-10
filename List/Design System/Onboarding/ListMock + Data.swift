//
//  ListMock + Data.swift
//  List
//
//  Created by Anton Cherkasov on 09.02.2026.
//

import Foundation

// MARK: - Nested Data
extension ListMock {

	struct Model {

		// MARK: - Data

		let showTags: Bool
		let tags: [TagMock]
		let rows: [RowMock]

		// MARK: - Initialization

			init(
				showTags: Bool = true,
				tags: [TagMock] = ListMockFactory.tags(),
				rows: [RowMock] = ListMockFactory.rows(count: 6)
			) {
				self.showTags = showTags
				self.tags = tags
				self.rows = rows
		}
	}

	struct TagMock: Identifiable {

		let id: UUID
		let title: String
		let iconName: IconName
		let state: TagState

		init(id: UUID = UUID(), title: String, iconName: IconName, state: TagState) {
			self.id = id
			self.title = title
			self.iconName = iconName
			self.state = state
		}
	}

	struct RowMock: Identifiable {

		let id: UUID
		let title: String
		let subtitle: String
		let isShimmering: Bool

		init(id: UUID = UUID(), title: String, subtitle: String, isShimmering: Bool = true) {
			self.id = id
			self.title = title
			self.subtitle = subtitle
			self.isShimmering = isShimmering
		}

		var isFocused: Bool {
			!isShimmering
		}

		var hasSubtitle: Bool {
			!subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
		}
	}
}
