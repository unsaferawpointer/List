//
//  FilterEditor.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI
import SwiftData

struct FilterEditor: View {

	@Environment(\.dismiss) var dismiss

	@Environment(\.modelContext) private var modelContext
	@Query private var tags: [Tag]

	@State var selection: Set<UUID>

	let completion: (Set<UUID>) -> Void

	// MARK: - Initialization

	init(selected: Set<UUID>, completion: @escaping (Set<UUID>) -> Void) {
		self._selection = State(initialValue: selected)
		self.completion = completion
	}

	var body: some View {
		NavigationStack {
			List {
				Section("Include") {
					ForEach(tags) { tag in
						Button {
							if selection.contains(tag.uuid) {
								selection.remove(tag.uuid)
							} else {
								selection.insert(tag.uuid)
							}
						} label: {
							HStack {
								Label(tag.title, systemImage: "tag")
									.foregroundStyle(.primary)
								Spacer()
								if selection.contains(tag.uuid) {
									Image(systemName: "checkmark")
								}
							}
						}
						.listItemTint(.primary)
					}
				}
			}
			.listStyle(.insetGrouped)
			.navigationTitle("Filter")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button(role: .close) {
						dismiss()
					}
				}
				ToolbarItem(placement: .bottomBar) {
					Spacer()
				}
				ToolbarItem(placement: .confirmationAction) {
					Button(role: .confirm) {
						completion(selection)
						dismiss()
					}
				}
			}
		}
	}
}

#Preview {
	FilterEditor(selected: []) { _ in }
		.modelContainer(for: Tag.self, inMemory: true)
}
