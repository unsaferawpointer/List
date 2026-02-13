//
//  ListMock.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI

struct ListMock {

	let model: Model

	// MARK: - Initialization

	init(model: Model) {
		self.model = model
	}

	init(showTags: Bool = true, focusedRow: Int? = nil) {
		self.init(
			model: Model(
				showTags: showTags,
				rows: ListMockFactory.rows(count: 6).enumerated().map { index, row in
					guard let focusedRow, index == focusedRow else {
						return row
					}
					return RowMock(id: row.id, title: row.title, subtitle: row.subtitle, isShimmering: false)
				}
			)
		)
	}
}

// MARK: - View
extension ListMock: View {

	var body: some View {
		List {
			if model.showTags {
				ScrollView(.horizontal) {
					HStack {
						ForEach(model.tags) { tag in
							TagView(title: tag.title, imageName: tag.iconName.imageName, state: tag.state)
						}
					}
					.toggleStyle(.button)
				}
				.scrollIndicators(.hidden)
				.padding(.vertical, 8)
			}
			ForEach(model.rows) { row in
				HStack(spacing: 12) {
					Circle()
						.foregroundStyle(.tertiary)
							.frame(width: 8, height: 8)
						VStack(alignment: .leading, spacing: 6) {
							Text(row.title)
								.font(.headline)
								.foregroundStyle(.primary)
								.redacted(reason: row.isFocused ? .invalidated : .placeholder)
							if row.hasSubtitle {
								Text(row.subtitle)
									.font(.subheadline)
									.foregroundStyle(.secondary)
									.redacted(reason: row.isFocused ? .invalidated : .placeholder)
							}
						}
						Spacer()
					}
				.blur(radius: row.isFocused ? 0.0 : 0.5)
				.opacity(row.isFocused ? 1.0 : 0.5)
				.animation(.spring(response: 0.28, dampingFraction: 0.85), value: model.rows.map(\.isShimmering))
				.listRowSeparator(.hidden)
			}
		}
		.listStyle(.inset)
		.scrollIndicators(.hidden)
		.overlay(
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color.gray.opacity(0.2), lineWidth: 1)
		)
	}
}

// MARK: - Helpers
private extension ListMock {

	func randomWidth() -> CGFloat {
		[180, 220, 260, 280].randomElement()!
	}
}

#Preview {
	VStack {
		ListMock(showTags: false)
		ListMock(showTags: true, focusedRow: 1)
	}
}
