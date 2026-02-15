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

	private var item: Item

	@FocusState private var focus: Bool

	@State private var text: String

	private let onChange: (String) -> Void

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
				TextField(ContentLocalization.itemCellPlaceholder, text: $text)
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
					.onChange(of: item.text) { oldValue, newValue in
						text = newValue
					}
				if showSubtitle {
					Text(subtitle)
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
		}
	}
}

// MARK: - Helpers
private extension ItemView {

	var showSubtitle: Bool {
		!(item.tags?.isEmpty == true)
	}

	var subtitle: String {
		item.tags?.map(\.title).joined(separator: " | ") ?? ""
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
