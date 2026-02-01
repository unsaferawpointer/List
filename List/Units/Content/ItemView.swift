//
//  ItemView.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import SwiftUI

#if os(iOS)
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
				if !(item.tags?.isEmpty == true) {
					Text(item.tags?.map(\.title).joined(separator: " | ") ?? "")
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
#endif

#if os(macOS)
struct ItemView: View {

	var item: Item

	@FocusState var focus: Bool

	@State var text: String

	let onChange: (String) -> Void

	// MARK: - Initialization

	init(item: Item, onChange: @escaping (String) -> Void = { _ in }) {
		self.item = item
		self._text = State(initialValue: item.text)
		self.onChange = onChange
	}

	var body: some View {
		HStack(spacing: 16) {
			Circle()
				.foregroundStyle(item.isCompleted ? .tertiary : .secondary)
				.frame(width: 4, height: 4)
			VStack(alignment: .leading) {
				TextField("Required", text: $text)
					.focused($focus)
					.foregroundStyle(item.isCompleted ? .secondary : .primary)
					.lineLimit(2)
					.strikethrough(item.isCompleted)
					.onSubmit {
						onChange(text)
					}
					.onChange(of: focus) {
						onChange(text)
					}
				if !(item.tags?.isEmpty == true) {
					Text(item.tags?.map(\.title).joined(separator: " | ") ?? "")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	ItemView(item: .init(text: "Default Item"))
	.frame(minWidth: 320, alignment: .leading)
	.padding()
	ItemView(item: .init(text: "Completed Item", rawStatus: Status.done.rawValue))
	.frame(minWidth: 320, alignment: .leading)
	.padding()
	ItemView(item: .init(text: "Editing Item"))
	.frame(minWidth: 320, alignment: .leading)
	.padding()
}
#endif
