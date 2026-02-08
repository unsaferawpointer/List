//
//  TagsSection + macOS.swift
//  List
//
//  Created by Anton Cherkasov on 30.01.2026.
//

import SwiftUI
import SwiftData

#if os(macOS)
import AppKit

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
					TagView(title: tag.title, imageName: tag.iconName.imageName ?? "tag", state: state(for: tag))
						.contentShape(Rectangle())
						.onTapGesture(count: 1) {
							switch (includedTags.contains(tag.uuid), excludedTags.contains(tag.uuid)) {
							case (true, false):
								includedTags.remove(tag.uuid)
								excludedTags.insert(tag.uuid)
							case (false, true):
								excludedTags.remove(tag.uuid)
							default:
								includedTags.insert(tag.uuid)
							}
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

	func state(for tag: Tag) -> TagState {
		if excludedTags.contains(tag.uuid) {
			return .excluded
		}
		if includedTags.contains(tag.uuid) {
			return .active
		}
		return .normal
	}

	func isOn(for tag: Tag) -> Binding<Bool> {
		return Binding {
			includedTags.contains(tag.uuid)
		} set: { newValue in
			if newValue {
				includedTags.insert(tag.uuid)
			} else {
				includedTags.remove(tag.uuid)
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
#endif
