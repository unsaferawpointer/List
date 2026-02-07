//
//  TagsSection.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI

#if os(iOS)
struct TagsSection: View {

	let tags: [Tag]

	@Binding var filter: Filter

	private let rows = [
		GridItem(.fixed(32), spacing: 8)
	]

	var body: some View {
		ScrollView(.horizontal) {
			LazyHGrid(
				rows: rows,
				alignment: .center,
				spacing: 8
			) {
				ForEach(tags) { tag in
					TagView(title: tag.title, state: state(for: tag))
						.contentShape(Rectangle())
						.onTapGesture(count: 1) {
							switch (filter.includedTag.contains(tag.uuid), filter.excludedTag.contains(tag.uuid)) {
							case (true, false):
								filter.includedTag.remove(tag.uuid)
								filter.excludedTag.insert(tag.uuid)
							case (false, true):
								filter.excludedTag.remove(tag.uuid)
							default:
								filter.includedTag.insert(tag.uuid)
							}
						}
				}
			}
			.scrollTargetLayout()
			.padding(.vertical, 6)
		}
		.scrollIndicators(.hidden)
		.scrollTargetBehavior(.viewAligned)
		.listRowSeparator(.hidden)
	}
}

extension TagsSection {

	func state(for tag: Tag) -> TagState {
		if filter.excludedTag.contains(tag.uuid) {
			return .excluded
		}
		if filter.includedTag.contains(tag.uuid) {
			return .active
		}
		return .normal
	}

	func buildMenu(for tag: Tag) -> [UIAction] {
		let isExcluded = filter.excludedTag.contains(tag.uuid)
		return
		[
			UIAction(
				title: isExcluded ? "Include" : "Exclude",
				image: UIImage(systemName: isExcluded ? "plus.circle.fill" : "xmark.circle")
			) { _ in
				if isExcluded {
					filter.excludedTag.remove(tag.uuid)
					filter.includedTag.insert(tag.uuid)
				} else {
					filter.excludedTag.insert(tag.uuid)
					filter.includedTag.remove(tag.uuid)
				}
			}
		]
	}
}

#Preview {
	TagsSection(
		tags: [
			.init(title: "Urgent"),
			.init(title: "Today"),
			.init(title: "Week"),
			.init(title: "Month"),
			.init(title: "Year"),
			.init(title: "Books"),
			.init(title: "Movies"),
			.init(title: "Music"),
			.init(title: "Travel")
		],
		filter: .constant(Filter())
	)
	.padding()
}
#endif
