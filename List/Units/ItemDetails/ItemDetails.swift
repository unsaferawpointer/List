//
//  ItemDetails.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import SwiftUI

struct ItemDetails: View {

	@Environment(\.dismiss) var dismiss

	@State var title: String

	@FocusState var isFocused: Bool

	@State var model: Model

	// MARK: - Initialization

	init(title: String, text: String, completion: ((String) -> Void)?) {
		self._title = .init(initialValue: title)
		self.model = Model(initialText: text, completion: completion)
	}

	var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField(model.textfieldHint, text: $model.text, axis: .vertical)
						.lineLimit(2)
						.focused($isFocused)
						.onAppear {
							self.isFocused = true
						}
				} footer: {
					if let errorMessage = model.textfieldErrorMessage {
						Text(errorMessage)
							.foregroundColor(.red)
					}
				}
			}
			.navigationTitle(title)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(role: .close) {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button(role: .confirm) {
						dismiss()
						model.confirm()
					}
					.disabled(!model.isValid)
				}
			}
		}
	}
}

//#Preview {
//	ItemDetails()
//}
