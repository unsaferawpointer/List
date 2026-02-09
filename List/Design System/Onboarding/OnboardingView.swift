//
//  OnboardingView.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI

struct OnboardingView: View {

	@Environment(\.dismiss) var dismiss
	@Environment(\.openWindow) private var openWindow

	private let steps: [OnboardingPage]

	@State private var state: OnboardingState

	init(steps: [OnboardingPage]) {
		self.steps = steps
		self._state = State(initialValue: OnboardingState(count: steps.count))
	}

	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				steps[state.index]
					.transition(state.transition)
					.animation(.easeInOut(duration: 0.35), value: state.index)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			Divider()
			controls
		}
	}

	private var controls: some View {
		HStack {
			Button("Back") {
				goBack()
			}
			.controlSize(.extraLarge)
			.keyboardShortcut(.cancelAction)
			.disabled(state.index == 0)
			Spacer()
			Button(state.index == steps.count - 1 ? "Done" : "Continue") {
				goForward()
			}
			.controlSize(.extraLarge)
			.keyboardShortcut(.defaultAction)
		}
		.padding()
	}
}

// MARK: - Helpers
private extension OnboardingView {

	func goForward() {
		if !state.goForward() {
			openWindow(id: "main")
			dismiss()
		}
	}

	func goBack() {
		state.goBack()
	}
}

// MARK: - Preview Data
fileprivate enum OnboardingViewPreviewData {

	static let steps: [OnboardingPage] =
	[
		OnboardingPage(
			title: "Welcome to List",
			subtitle: "No date, no priorities — only focus"
		) {
			ListMock(showTags: false, focusedRow: 2)
				.padding()
		},
		OnboardingPage(
			title: "Filter with tags",
			subtitle: "Choose what to include or exclude"
		) {
			ListMock(showTags: true, focusedRow: nil)
				.padding()
		}
	]
}

#Preview {
	OnboardingView(steps: OnboardingViewPreviewData.steps)
}
