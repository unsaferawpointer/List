//
//  TagView.swift
//  List
//
//  Created by Anton Cherkasov on 07.02.2026.
//

import SwiftUI

struct TagView: View {

	let title: String

	let imageName: String?

	let state: TagState

	var body: some View {
		HStack(spacing: 6) {
			Image(systemName: systemName)
				.foregroundStyle(foregroundColor)
				.font(.footnote)
				.fontWeight(.semibold)
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
		.padding(2)
	}
}

// MARK: - Computed Properties
private extension TagView {

	var systemName: String {
		switch state {
		case .normal:
			imageName ?? "tag"
		case .active:
			"checkmark"
		case .excluded:
			"xmark"
		}
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

#Preview("LTR") {
	VStack {
		TagView(title: "Travel", imageName: "bolt", state: .normal)
		TagView(title: "Travel", imageName: "bolt", state: .active)
		TagView(title: "Travel", imageName: "bolt", state: .excluded)
	}
	.padding()
	.environment(\.colorScheme, .light)
	.environment(\.layoutDirection, .leftToRight)

	VStack {
		TagView(title: "Travel", imageName: "bolt", state: .normal)
		TagView(title: "Travel", imageName: "bolt", state: .active)
		TagView(title: "Travel", imageName: "bolt", state: .excluded)
	}
	.padding()
	.environment(\.colorScheme, .dark)
	.environment(\.layoutDirection, .leftToRight)
}

#Preview("RTL") {
	VStack {
		TagView(title: "Travel", imageName: "bolt", state: .normal)
		TagView(title: "Travel", imageName: "bolt", state: .active)
		TagView(title: "Travel", imageName: "bolt", state: .excluded)
	}
	.padding()
	.environment(\.colorScheme, .light)
	.environment(\.layoutDirection, .rightToLeft)

	VStack {
		TagView(title: "Travel", imageName: "bolt", state: .normal)
		TagView(title: "Travel", imageName: "bolt", state: .active)
		TagView(title: "Travel", imageName: "bolt", state: .excluded)
	}
	.padding()
	.environment(\.colorScheme, .dark)
	.environment(\.layoutDirection, .rightToLeft)
}
