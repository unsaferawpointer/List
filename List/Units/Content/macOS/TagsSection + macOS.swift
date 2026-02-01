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
					TagView(
						title: tag.title,
						foregroundColor: excludedTags.contains(tag.uuid) ? .systemRed : .secondaryLabelColor,
						imageName: excludedTags.contains(tag.uuid) ? "xmark.circle" : tag.iconName.imageName ?? "tag",
						isOn: includedTags.contains(tag.uuid) || excludedTags.contains(tag.uuid)
					) {
						if includedTags.contains(tag.uuid) {
							includedTags.remove(tag.uuid)
						} else {
							includedTags.insert(tag.uuid)
						}
						excludedTags.remove(tag.uuid)
					} onExclude: {
						excludedTags.insert(tag.uuid)
						includedTags.remove(tag.uuid)
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
