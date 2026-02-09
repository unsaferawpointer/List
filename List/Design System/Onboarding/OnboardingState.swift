import SwiftUI

@Observable
final class OnboardingState {

	// MARK: - State
	private(set) var index: Int = 0
	private(set) var direction: Direction = .forward

	// MARK: - Configuration
	private let count: Int

	// MARK: - Initialization
	init(count: Int) {
		self.count = max(count, 0)
	}
}

// MARK: - Public API
extension OnboardingState {

	@discardableResult
	func goForward() -> Bool {
		guard index < count - 1 else {
			return false
		}
		direction = .forward
		index += 1
		return true
	}

	func goBack() {
		guard index > 0 else {
			return
		}
		direction = .backward
		index -= 1
	}
}

// MARK: - Types
extension OnboardingState {

	enum Direction {
		case forward, backward
	}
}

// MARK: - Computed Properties
extension OnboardingState {

	var transition: AnyTransition {
		switch direction {
		case .forward:
			return .asymmetric(
				insertion: .move(edge: .trailing),
				removal: .move(edge: .leading)
			)
		case .backward:
			return .asymmetric(
				insertion: .move(edge: .leading),
				removal: .move(edge: .trailing)
			)
		}
	}
}
