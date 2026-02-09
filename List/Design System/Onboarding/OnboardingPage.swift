//
//  OnboardingPage.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI

struct OnboardingPage: View {

	let title: String
	let subtitle: String

	let content: AnyView

	// MARK: - Initialization

	init<Content: View>(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
		self.title = title
		self.subtitle = subtitle
		self.content = AnyView(content())
	}

	var body: some View {
		VStack(spacing: 8) {
			VStack(alignment: .center, spacing: 8) {
				Text(title)
					.font(.largeTitle)
					.fontWeight(.semibold)
					.multilineTextAlignment(.center)

				Text(subtitle)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.init(top: 56, leading: 12, bottom: 12, trailing: 12))
			content
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

#Preview {
	OnboardingPage(
		title: "Filter with tags",
		subtitle: "Choose what to include or exclude"
	) {
		ListMock(showTags: true, focusedRow: nil)
	}
}
