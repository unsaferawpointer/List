//
//  TagsPicker.swift
//  Multiplatform
//
//  Created by Anton Cherkasov on 28.12.2025.
//

import SwiftUI
import SwiftData

struct TagsPicker {

	@Environment(\.dismiss) var dismiss

	@Environment(\.modelContext) private var modelContext

	@Query private var tags: [Tag]
	@Query private var items: [Item]

	let completion: (Set<PersistentIdentifier>) -> Void

	@State var changes: [PersistentIdentifier: Bool] = [:]

	// MARK: - Initialization

	init(items: Set<PersistentIdentifier>, completion: @escaping (Set<PersistentIdentifier>) -> Void) {
		let predicate = #Predicate<Item> { item in
			items.contains(item.id)
		}
		self._items = Query(filter: predicate, animation: .default)
		self.completion = completion
	}
}

// MARK: - Helpers
extension TagsPicker {

	func sources(for tag: PersistentIdentifier) -> ControlState {
		if let value = changes[tag] {
			return value ? .on : .off
		}
		let allChecked = items.allSatisfy { $0.tags?.contains(where: { $0.id == tag }) == true }
		let allUnchecked = items.allSatisfy { !($0.tags?.contains(where: { $0.id == tag }) == false)}
		if allChecked {
			return .on
		} else if allUnchecked {
			return .off
		} else {
			return .mixed
		}
	}

	enum ControlState {
		case off
		case mixed
		case on
	}
}

// MARK: - View
extension TagsPicker: View {

	var body: some View {
		NavigationStack {
			Group {
				if tags.isEmpty {
					ContentUnavailableView {
						Label("No Tags", systemImage: "tag")
					} description: {
						Text("Tags make organization easier.\n To create one, go to \"Settings\" → \"Tags\".")
							.multilineTextAlignment(.center)
					}
				} else {
					Form {
						ForEach(tags, id: \.id) { tag in
							Button {
								let state = sources(for: tag.id)
								switch state {
								case .off, .mixed:
									changes[tag.id] = true
								case .on:
									changes[tag.id] = false
								}
							} label: {
								HStack {
									Label(tag.title, systemImage: "tag")
									Spacer()
									switch sources(for: tag.id) {
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
							.listItemTint(.primary)
						}
					}
					.listStyle(.insetGrouped)
				}
			}
			.navigationTitle("Select tags")
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
						dismiss()
						for (key, value) in changes {
							for item in items {
								if value, let tag = tags.first(where: { $0.id == key }) {
									item.tags?.append(tag)
								} else {
									item.tags?.removeAll(where: { $0.id == key })
								}
							}
						}
					}
				}
			}
		}
	}
}

#Preview {
	TagsPicker(items: []) { _ in }
		.modelContainer(for: Tag.self, inMemory: true)
		.modelContainer(for: Item.self, inMemory: true)
}
