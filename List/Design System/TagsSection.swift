//
//  TagsSection.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import SwiftUI
import SwiftData

struct TagsSection: View {

	@Query(
		filter: #Predicate<Tag> { tag in !tag.isHidden },
		sort: [.byIndex, .byTimestamp],
		animation: .default
	) var tags: [Tag]

	@Binding var includedTags: Set<UUID>

	@Binding var excludedTags: Set<UUID>

	var body: some View {
		ScrollView(.horizontal) {
			HStack {
				ForEach(tags) { tag in
					TagView(title: tag.title, iconName: tag.iconName, state: state(for: tag.uuid))
						.contentShape(Rectangle())
						.onTapGesture {
							onTap(id: tag.uuid)
						}
				}
			}
			.toggleStyle(.button)
		}
		.scrollIndicators(.hidden)
	}
}

// MARK: - Helpers
private extension TagsSection {

	func onTap(id: UUID) {
		switch (includedTags.contains(id), excludedTags.contains(id)) {
		case (true, false):
			includedTags.remove(id)
			excludedTags.insert(id)
		case (false, true):
			excludedTags.remove(id)
		default:
			includedTags.insert(id)
		}
	}

	func state(for id: UUID) -> TagState {
		if excludedTags.contains(id) {
			return .excluded
		}
		if includedTags.contains(id) {
			return .active
		}
		return .normal
	}

	func isOn(for id: UUID) -> Binding<Bool> {
		return Binding {
			includedTags.contains(id)
		} set: { newValue in
			if newValue {
				includedTags.insert(id)
			} else {
				includedTags.remove(id)
			}
		}
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	TagsSection(includedTags: .constant([]), excludedTags: .constant([]))
		.modelContainer(PreviewContainer.previewContainer)
		.padding()
		.fixedSize()
}
