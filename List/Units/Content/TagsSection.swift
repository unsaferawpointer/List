//
//  TagsSection.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI

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
					HStack {
						Image(systemName: filter.excludedTag.contains(tag.uuid) ? "xmark.circle" : tag.iconName.imageName ?? "tag")
							.foregroundStyle(filter.excludedTag.contains(tag.uuid) ? .red : .primary)
						Text(tag.title)
							.foregroundStyle(filter.excludedTag.contains(tag.uuid) ? .red : .primary)
							.font(.callout)
							.fontWeight(.regular)
						}
					.padding(.horizontal, 12)
					.padding(.vertical, 8)
					.background {
						Capsule(style: .continuous)
							.fill(
								!filter.includedTag.contains(tag.uuid) || filter.excludedTag.contains(tag.uuid)
									? Color(uiColor: .quaternarySystemFill)
									: Color(uiColor: .tintColor).opacity(0.4)
							)
					}
					.onTapGesture {
						withAnimation {
							if filter.includedTag.contains(tag.uuid) {
								filter.excludedTag.insert(tag.uuid)
								filter.includedTag.remove(tag.uuid)
							} else {
								if filter.excludedTag.contains(tag.uuid) {
									filter.excludedTag.remove(tag.uuid)
								} else {
									filter.includedTag.insert(tag.uuid)
								}
							}
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
