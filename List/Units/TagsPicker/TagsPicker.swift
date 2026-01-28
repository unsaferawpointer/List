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

	@State var model: Model

	let completion: (Set<PersistentIdentifier>) -> Void

	// MARK: - Initialization

	init(items: Set<PersistentIdentifier>, completion: @escaping (Set<PersistentIdentifier>) -> Void) {
		let predicate = #Predicate<Item> { item in
			items.contains(item.id)
		}
		self._items = Query(filter: predicate, animation: .default)
		self.model = Model(selectedItems: items)
		self.completion = completion
	}
}

// MARK: - View
extension TagsPicker: View {

	var body: some View {
		NavigationStack {
			Group {
				if tags.isEmpty {
					ContentUnavailableView {
						Label(model.placeholderTitle, systemImage: "tag")
					} description: {
						Text(model.placeholderMessage)
							.multilineTextAlignment(.center)
					}
				} else {
					List {
						ForEach(tags, id: \.id) { tag in
							TagsPicker.TagView(
								title: tag.title,
								imageName: tag.iconName.imageName ?? "tag",
								state: model.sources(for: tag.id, items: items)
							) {
								model.toggleState(for: tag.id, items: items)
							}
							.listItemTint(.primary)
							.listRowSeparator(.hidden)
						}
					}
					.scrollIndicators(.hidden)
					#if os(iOS)
					.listStyle(.inset)
					#endif
				}
			}
			.navigationTitle(model.navigationTitle)
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
						dismiss()
						model.save(items: items, tags: tags)
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
