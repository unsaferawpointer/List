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

	@AppStorage("selected-settings-tab") private var selectedSettingsTab = SettingsTab.tags

	// MARK: - Internal State

	@State var selection: Set<PersistentIdentifier> = []

	var body: some View {
		TabView(selection: $selectedSettingsTab) {
			Tab("Tags", systemImage: "tag", value: SettingsTab.tags) {
				TagsEditor()
			}
			.tabPlacement(.pinned)
		}
	}
}

#Preview {
	SettingsView()
}
#endif
