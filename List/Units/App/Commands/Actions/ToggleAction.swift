//
//  ToggleAction.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import SwiftUI

struct ToggleAction<T> {

	let title: String
	let isEnabled: Bool
	let source: [Binding<Bool>]

	// MARK: - Initialization

	init(
		title: String,
		isEnabled: Bool,
		source: [Binding<Bool>]
	) {
		self.title = title
		self.isEnabled = isEnabled
		self.source = source
	}
}
