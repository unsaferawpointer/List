//
//  TagView.swift
//  List
//
//  Created by Anton Cherkasov on 07.02.2026.
//

import SwiftUI

struct TagView: View {

	let title: String

	let imageName: String

	let state: TagState

	var body: some View {
		HStack(spacing: 6) {
			stateIcon

			Text(title)
				.foregroundStyle(foregroundColor)
				.font(.footnote)
				.fontWeight(.semibold)
		}
		.padding(.horizontal, 12)
		.padding(.vertical, 6)
		.background(background)
		.clipShape(Capsule())
		.overlay(
			Capsule()
				.strokeBorder(borderColor, lineWidth: 0.5)
		)
	}
}

// MARK: - Helpers
private extension TagView {

	var stateIcon: some View {
		Group {
			switch state {
			case .active:
				Image(systemName: "checkmark")
			case .excluded:
				Image(systemName: "xmark")
			case .normal:
				Image(systemName: imageName)
			}
		}
		.foregroundStyle(foregroundColor)
		.font(.footnote)
		.fontWeight(.semibold)
	}

	var foregroundColor: Color {
		switch state {
		case .active:
			Color.accentColor
		case .excluded:
			Color.red
		case .normal:
			Color.primary
		}
	}

	var background: Color {
		switch state {
		case .active:
			Color.accentColor.opacity(0.15)
		case .excluded:
			Color.red.opacity(0.1)
		case .normal:
			Color.secondary.opacity(0.1)
		}
	}

	var borderColor: Color {
		switch state {
		case .active:
			Color.accentColor.opacity(0.4)
		case .excluded:
			Color.red.opacity(0.25)
		case .normal:
			Color.gray.opacity(0.2)
		}
	}
}

#Preview {
	TagView(title: "Travel", imageName: "airplane", state: .active)
		.padding()
	TagView(title: "Travel", imageName: "airplane", state: .excluded)
		.padding()
	TagView(title: "Travel", imageName: "airplane", state: .normal)
		.padding()
}
