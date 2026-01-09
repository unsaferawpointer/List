//
//  ItemView.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import SwiftUI

struct ItemView: View {

	let isEditing: Bool

	var item: Item

	var body: some View {
		HStack(spacing: 16) {
			if !isEditing {
				Circle()
					.foregroundStyle(item.isCompleted ? .secondary : .primary)
					.frame(width: 4, height: 4)
			}
			VStack(alignment: .leading) {
				Text(item.text)
					.foregroundStyle(item.isCompleted ? .secondary : .primary)
					.lineLimit(2)
					.strikethrough(item.isCompleted)
				if !item.tags.isEmpty {
					Text(item.tags.map(\.title).joined(separator: " | "))
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	ItemView(isEditing: false, item: .init(text: "Default Item"))
		.frame(minWidth: 320, alignment: .leading)
		.padding()
	ItemView(isEditing: false, item: .init(text: "Completed Item", rawStatus: Status.done.rawValue))
		.frame(minWidth: 320, alignment: .leading)
		.padding()
	ItemView(isEditing: true, item: .init(text: "Editing Item"))
		.frame(minWidth: 320, alignment: .leading)
		.padding()
}
