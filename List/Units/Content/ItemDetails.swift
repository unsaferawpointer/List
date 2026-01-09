//
//  ItemDetails.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import SwiftUI

struct ItemDetails: View {

	@Environment(\.dismiss) var dismiss

	@State var text: String = ""

	@FocusState var isFocused: Bool

	@State var title: String

	var completion: ((String) -> Void)?

	// MARK: - Initialization

	init(title: String, text: String, completion: ((String) -> Void)?) {
		self._text = State(initialValue: text)
		self._title = State(initialValue: title)
		self.completion = completion
	}

	var body: some View {
		NavigationStack {
			Form {
				TextField("Required", text: $text, axis: .vertical)
					.lineLimit(2)
					.focused($isFocused)
					.onAppear {
						self.isFocused = true
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
						completion?(text)
						dismiss()
					}
				}
			}
		}
	}
}

//#Preview {
//	ItemDetails()
//}
