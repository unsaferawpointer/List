//
//  FilterView.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import SwiftUI
import SwiftData

struct FilterView: View {

	@Environment(\.dismiss) private var dismiss

	@Binding var filter: Filter

	@Query(
		filter: #Predicate<Tag> { tag in !tag.isHidden },
		sort: [.byIndex, .byTimestamp],
		animation: .default
	) var tags: [Tag]

	var body: some View {
		NavigationStack {
			Form {
				OptionButton(
					imageName: nil,
					title: FilterLocalization.Filter.completed,
					matchType: filter.completionState
				) {
					filter.nextStatus()
				}

				if !tags.isEmpty {
					Section(FilterLocalization.Filter.tagsSection) {
						ForEach(tags) { tag in
							OptionButton(
								imageName: tag.iconName.imageName ?? "tag",
								title: tag.title,
								matchType: filter.matchType(for: tag.uuid)
							) {
								filter.nextState(for: tag.uuid)
							}
						}
					}
				}

				if !filter.isEmpty {
					Button {
						filter = Filter()
					} label: {
						HStack {
							Spacer()
							Text(FilterLocalization.Footer.clear)
							Spacer()
						}
					}
				}
			}
			.formStyle(.grouped)
			.scrollIndicators(.hidden)
			#if os(iOS)
			.navigationTitle(FilterLocalization.NavigationBar.title)
			.navigationBarTitleDisplayMode(.inline)
			#endif
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button(FilterLocalization.Toolbar.done) {
						dismiss()
					}
				}
			}
		}
		.presentationDetents([.medium, .large])
	}
}

#Preview {
	FilterView(filter: .constant(Filter()))
		.modelContainer(PreviewContainer.previewContainer)
}
