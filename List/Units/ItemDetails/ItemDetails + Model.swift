//
//  ItemDetails + Model.swift
//  List
//
//  Created by Anton Cherkasov on 14.01.2026.
//

import Foundation

extension ItemDetails {

	@Observable
	final class Model {

		var text: String = ""

		@ObservationIgnored
		private let validator: TextValidator

		@ObservationIgnored
		let completion: ((String) -> Void)?

		// MARK: - Initialization
		init(initialText: String, validator: TextValidator = .init(), completion: ((String) -> Void)?) {
			self.text = initialText
			self.validator = validator
			self.completion = completion
		}
	}
}

// MARK: - Public Interface
extension ItemDetails.Model {

	var isValid: Bool {
		return validator.validate(text: text) == .isValid
	}

	func confirm() {
		completion?(text)
	}
}

// MARK: - Localization
extension ItemDetails.Model {

	var textfieldHint: String {
		return String(localized: "Required", table: "ItemDetailsLocalizable", comment: "Textfield hint")
	}

	var textfieldErrorMessage: String? {
		return validator.validate(text: text).errorMessage
	}
}

private extension TextValidator.State {

	var errorMessage: String? {
		switch self {
		case .isValid:
			return nil
		case .tooShort:
			return "Minimum length not reached"
		}
	}
}
