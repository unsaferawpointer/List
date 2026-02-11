//
//  OnboardingView.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI

struct OnboardingView {

	@Environment(\.dismiss) var dismiss

	private let model: Model

	@State private var state: OnboardingState

	let onFinish: () -> Void

	init(model: Model, onFinish: @escaping () -> Void = { }) {
		self.model = model
		self.onFinish = onFinish
		self._state = State(initialValue: OnboardingState(count: model.steps.count))
	}
}

// MARK: - View
extension OnboardingView: View {

	var body: some View {
		VStack(spacing: 0) {
			ZStack {
				OnboardingPage(model: model.steps[state.index])
					.transition(state.transition)
					.animation(.easeInOut(duration: 0.35), value: state.index)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			Divider()
			controls
		}
	}
}

// MARK: - Model
extension OnboardingView {

	struct Model {

		let steps: [OnboardingPage.Model]

		init(steps: [OnboardingPage.Model]) {
			self.steps = steps
		}
	}
}

// MARK: - Helpers
private extension OnboardingView {

	var controls: some View {
		HStack {
			Button(OnboardingTextFactory.Controls.back) {
				goBack()
			}
			.controlSize(.extraLarge)
			.keyboardShortcut(.cancelAction)
			.disabled(state.index == 0)
			Spacer()
			Button(state.index == model.steps.count - 1 ? OnboardingTextFactory.Controls.done : OnboardingTextFactory.Controls.continue) {
				goForward()
			}
			.controlSize(.extraLarge)
			.keyboardShortcut(.defaultAction)
		}
		.padding()
	}

	func goForward() {
		if !state.goForward() {
			dismiss()
			onFinish()
		}
	}

	func goBack() {
		state.goBack()
	}
}

// MARK: - Preview Data
fileprivate enum OnboardingViewPreviewData {

	static let model: OnboardingView.Model =
		OnboardingModelFactory.makeModel(focusedRow: 2)
}

#Preview {
	OnboardingView(model: OnboardingViewPreviewData.model)
}
