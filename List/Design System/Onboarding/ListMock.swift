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

	init(showTags: Bool = true, focusedRow: Int? = nil) {
		self.model = Model(
			showTags: showTags,
			rows: ListMockFactory.rows(count: 6, focusedRow: focusedRow)
		)
	}
}

// MARK: - View
extension ListMock: View {

	var body: some View {
		VStack(spacing: 14) {
			if model.showTags {
				ScrollView(.horizontal) {
					HStack {
						ForEach(model.tags) { tag in
							TagView(title: tag.title, iconName: tag.iconName, state: tag.state)
						}
					}
					.toggleStyle(.button)
				}
				.scrollIndicators(.hidden)
				.padding(.vertical, 8)
			}
			ForEach(model.rows) { row in
				let isFocused = !row.isShimmering

				HStack(spacing: 12) {
					Circle()
						.foregroundStyle(.tertiary)
						.frame(width: 8, height: 8)
					VStack(alignment: .leading, spacing: 6) {
						Text(row.title)
							.font(.headline)
							.foregroundStyle(.primary)
							.redacted(reason: isFocused ? .invalidated : .placeholder)
						Text(row.subtitle)
							.font(.subheadline)
							.foregroundStyle(.secondary)
							.redacted(reason: isFocused ? .invalidated : .placeholder)
					}
					Spacer()
				}
				.blur(radius: isFocused ? 0.0 : 0.5)
				.opacity(isFocused ? 1.0 : 0.5)
				.animation(.spring(response: 0.28, dampingFraction: 0.85), value: model.rows.map(\.isShimmering))
			}
		}
		.padding(24)
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
