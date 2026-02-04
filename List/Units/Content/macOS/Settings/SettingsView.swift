//
//  SettingsView.swift
//  List
//
//  Created by Anton Cherkasov on 04.02.2026.
//

#if os(macOS)
import SwiftUI
import SwiftData

struct SettingsView: View {

	@Environment(\.modelContext) var modelContext

	@Query(sort: [SortDescriptor<Tag>.byIndex, .byTimestamp], animation: .default) var tags: [Tag]

	// MARK: - Internal State

	@State var selection: Set<PersistentIdentifier> = []

	var body: some View {
		TabView {
			Tab("Tags", systemImage: "tag") {
				VStack(spacing: 0) {
					List(selection: $selection) {
						ForEach(tags) { tag in
							HStack {
								Image(systemName: tag.iconName.imageName ?? "tag")
									.foregroundStyle(tag.isHidden ? .secondary : .primary)
								TextField("Required", text: .init(get: {
									tag.title
								}, set: { newValue in
									tag.title = newValue
								}))
								.foregroundStyle(tag.isHidden ? .secondary : .primary)
							}
						}
						.onMove { indices, target in
							DataManager.moveTags(indices, to: target, in: modelContext, all: tags)
						}
					}
					.listStyle(.inset(alternatesRowBackgrounds: true))
					.contextMenu(forSelectionType: PersistentIdentifier.self) { selected in
						buildMenu(for: selected)
					}
					Divider()
					HStack {
						Button {
							addTag()
						} label: {
							Image(systemName: "plus")
						}
						Spacer()
					}
					.padding()
				}
			}
		}
	}
}

// MARK: - Binding
private extension SettingsView {

	func hiddenSources(for selected: Set<PersistentIdentifier>) -> [Binding<Bool>] {
		return tags.filter { tag in
			selected.contains(tag.id)
		}.map { item in
			Binding {
				item.isHidden
			} set: { newValue in
				item.isHidden = newValue
			}
		}
	}
}

// MARK: - Builders
private extension SettingsView {

	@ViewBuilder
	func buildMenu(for selected: Set<PersistentIdentifier>) -> some View {
		Toggle(sources: hiddenSources(for: selected), isOn: \.self) {
			Text("Hidden")
		}
		.keyboardShortcut(.return, modifiers: .command)
		Divider()
		Button(role: .destructive) {
			withAnimation {
				DataManager.deleteTags(selected, in: modelContext, all: tags)
			}
		} label: {
			Label("Delete", systemImage: "trash")
		}
		.keyboardShortcut(.delete, modifiers: .command)
	}
}

// MARK: - Helpers
private extension SettingsView {

	func addTag() {
		withAnimation {
			_ = DataManager.addTag(with: "New Tag", to: modelContext, all: tags)
		}
	}

	func setVisibility(selected: Set<PersistentIdentifier>, newValue: Bool) {
		withAnimation {
			tags.filter {
				selected.contains($0.id)
			}.forEach {
				$0.isHidden = newValue
			}
		}
	}
}

#Preview {
	SettingsView()
}
#endif
