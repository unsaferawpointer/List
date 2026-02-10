//
//  OnboardingPage.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI

struct OnboardingPage {

	let model: Model

	// MARK: - Initialization

	init(model: Model) {
		self.model = model
	}
}

// MARK: - View
extension OnboardingPage: View {

	var body: some View {
		VStack(spacing: 8) {
			VStack(alignment: .center, spacing: 8) {
				Text(model.title)
					.font(.largeTitle)
					.fontWeight(.semibold)
					.multilineTextAlignment(.center)

				Text(model.subtitle)
					.foregroundColor(.secondary)
					.multilineTextAlignment(.center)
			}
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.init(top: 56, leading: 12, bottom: 12, trailing: 12))
			ListMock(model: model.listMock)
				.padding()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
	}
}

// MARK: - Nested Data Structs
extension OnboardingPage {

	struct Model {
		
		let title: String
		let subtitle: String
		let listMock: ListMock.Model

		// MARK: - Initialization

		init(title: String, subtitle: String, listMock: ListMock.Model) {
			self.title = title
			self.subtitle = subtitle
			self.listMock = listMock
		}
	}
}

#Preview {
	OnboardingPage(
		model: .init(
			title: OnboardingTextFactory.Pages.tagsTitle,
			subtitle: OnboardingTextFactory.Pages.tagsSubtitle,
			listMock: .init(showTags: true)
		)
	)
}
