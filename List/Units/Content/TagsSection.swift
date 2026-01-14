//
//  TagsSection.swift
//  List
//
//  Created by Anton Cherkasov on 10.01.2026.
//

import SwiftUI

struct TagsSection: View {

	let tags: [Tag]

	@Binding var selectedTags: Set<UUID>

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
					Button {
						withAnimation {
							if selectedTags.contains(tag.uuid) {
								selectedTags.remove(tag.uuid)
							} else {
								selectedTags.insert(tag.uuid)
							}
						}
					} label: {
						HStack {
							Image(systemName: "tag")
							Text(tag.title)
								.font(.callout)
								.fontWeight(.regular)
						}
						.padding(.horizontal, 12)
						.padding(.vertical, 6)
						.background {
							Capsule(style: .continuous)
								.fill(
									!selectedTags.contains(tag.uuid)
										? Color(uiColor: .quaternarySystemFill)
										: Color(uiColor: .tintColor).opacity(0.4)
								)
						}
					}
					.buttonStyle(.plain)
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
		selectedTags: .constant([])
	)
	.padding()
}
