//
//  TagsPicker + TagView.swift
//  List
//
//  Created by Anton Cherkasov on 28.01.2026.
//

import SwiftUI

extension TagsPicker {

	struct TagView {

		let title: String

		let imageName: String

		let state: ControlState

		var completion: () -> Void
	}
}

extension TagsPicker.TagView: View {

	var body: some View {
		Button {
			completion()
		} label: {
			HStack {
				HStack {
					Image(systemName: imageName)
						.foregroundStyle(.secondary)
					Text(title)
				}
				Spacer()
				switch state {
				case .off:
					EmptyView()
				case .mixed:
					Image(systemName: "minus")
				case .on:
					Image(systemName: "checkmark")
				}
			}
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
	}
}

#Preview {
	TagsPicker.TagView(title: "Urgent", imageName: "bolt", state: .mixed) {
		
	}
}
