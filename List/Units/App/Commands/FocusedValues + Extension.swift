//
//  FocusedValues + Extension.swift
//  List
//
//  Created by Anton Cherkasov on 22.02.2026.
//

import SwiftUI

extension FocusedValues {

	var deleteAction: ButtonAction<DeleteAction>? {
		get { self[ActionKey<ButtonAction<DeleteAction>>.self] }
		set { self[ActionKey<ButtonAction<DeleteAction>>.self] = newValue }
	}

	var completionAction: ToggleAction<CompletionAction>? {
		get { self[ActionKey<ToggleAction<CompletionAction>>.self] }
		set { self[ActionKey<ToggleAction<CompletionAction>>.self] = newValue }
	}
}
