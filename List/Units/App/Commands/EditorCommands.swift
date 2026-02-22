//
//  EditorCommands.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import SwiftUI

struct EditorCommands {

	@FocusedValue(\.deleteAction) private var deleteAction
	@FocusedValue(\.completionAction) private var completionAction
}

// MARK: - Commands
extension EditorCommands: Commands {

	var body: some Commands {
		CommandMenu("Editor") {
			if let completionAction, !completionAction.source.isEmpty {
				Toggle(sources: completionAction.source, isOn: \.self) {
					Text(completionAction.title)
				}
				.keyboardShortcut(.return, modifiers: .command)
				.disabled(!completionAction.isEnabled)
			}
			Divider()
			if let deleteAction {
				Button(role: .destructive) {
					deleteAction.perform()
				} label: {
					Label(deleteAction.title, systemImage: "trash")
				}
				.keyboardShortcut(.delete, modifiers: .command)
				.disabled(!deleteAction.isEnabled)
			}
		}
	}
}
