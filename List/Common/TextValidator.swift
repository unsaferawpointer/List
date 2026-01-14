//
//  TextValidator.swift
//  List
//
//  Created by Anton Cherkasov on 14.01.2026.
//

import Foundation

final class TextValidator { }

extension TextValidator {

	func validate(text: String) -> State {
		return !text.isEmpty ? .isValid : .tooShort
	}
}

extension TextValidator {

	enum State {
		case isValid
		case tooShort
	}
}
