//
//  OptionButton.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import SwiftUI

struct OptionButton: View {

	let imageName: String?

	let title: String

	let matchType: Filter.MatchType

	let onTap: () -> Void

	var body: some View {
		Button(role: .confirm) {
			onTap()
		} label: {
			HStack(spacing: 12) {
				if let imageName {
					Image(systemName: imageName)
				}
				Text(title)
				Spacer()
				Image(systemName: imageName(for: matchType))
					.foregroundColor(color(for: matchType))
			}
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
	}
}

// MARK: - Helpers
private extension OptionButton {

	func imageName(for matchType: Filter.MatchType) -> String {
		switch matchType {
		case .any:
			"circle"
		case .include:
			"checkmark.circle.fill"
		case .exlude:
			"xmark.circle.fill"
		}
	}

	func color(for matchType: Filter.MatchType) -> Color {
		switch matchType {
		case .any:		.secondary
		case .include:	.accentColor
		case .exlude:	.red
		}
	}
}

#Preview {
	OptionButton(imageName: "star", title: "Favorite", matchType: .include) {
		
	}
}
