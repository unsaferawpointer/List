//
//  ButtonAction.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

struct ButtonAction<T> {

	let title: String
	let isEnabled: Bool
	let perform: () -> Void

	// MARK: - Initialization

	init(
		title: String,
		isEnabled: Bool,
		perform: @escaping () -> Void
	) {
		self.title = title
		self.isEnabled = isEnabled
		self.perform = perform
	}
}
