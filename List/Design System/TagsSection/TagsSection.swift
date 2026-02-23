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

	@Binding var completionState: Filter.MatchType

	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack {
				TagView(
					title: String(
						localized: "tags-section.completed",
						table: "TagsSectionLocalizable"
					),
					imageName: "checkmark",
					state: completionState.state
				)
				.contentShape(Rectangle())
				.onTapGesture {
					onTapCompleted()
				}
				if !tags.isEmpty {
					Divider()
				}
				ForEach(tags) { tag in
					TagView(title: tag.title, imageName: tag.iconName.imageName, state: state(for: tag.uuid))
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

	func onTapCompleted() {
		switch completionState {
		case .any:
			completionState = .include
		case .include:
			completionState = .exlude
		case .exlude:
			completionState = .any
		}
	}

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

private extension Filter.MatchType {

	var state: TagState {
		switch self {
		case .exlude:
			return .excluded
		case .include:
			return .active
		case .any:
			return .normal
		}
	}
}

#Preview(traits: .sizeThatFitsLayout) {
	TagsSection(includedTags: .constant([]), excludedTags: .constant([]), completionState: .constant(.any))
		.modelContainer(PreviewContainer.previewContainer)
		.padding()
		.fixedSize()
}
