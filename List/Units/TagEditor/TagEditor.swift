//
//  TagEditor.swift
//  Multiplatform
//
//  Created by Anton Cherkasov on 29.12.2025.
//

import SwiftUI

struct TagEditor {

	@Environment(\.dismiss) var dismiss

	@State var title: String

	@State var model: Model

	@State var isIconPickerPresented: Bool = false

	var completion: ((Model) -> Void)?

	// MARK: - Initialization

	init(title: String, model: Model, completion: ((Model) -> Void)?) {
		self._title = State(initialValue: title)
		self._model = State(initialValue: model)
		self.completion = completion
	}
}

// MARK: - View
extension TagEditor: View {

	var body: some View {
		NavigationStack {
			Form {
				LabeledContent("Name") {
					TextField("Required", text: $model.name)
				}
				NavigationLink {
					IconPicker(icon: $model.iconName)
				} label: {
					LabeledContent("Icon") {
						if model.iconName == .none {
							Text("No Selected")
						} else {
							Image(systemName: model.iconName.imageName ?? "tag")
						}
					}
				}
			}
			.navigationTitle(title)
			#if os(iOS)
			.navigationBarTitleDisplayMode(.inline)
			#endif
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(role: .close) {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button(role: .confirm) {
						completion?(model)
						dismiss()
					}
				}
			}
		}
	}
}

#Preview {
	TagEditor(title: "Edit Tag", model: .init(name: "Default Tag", iconName: .bolt)) { newModel in

	}
}
