//
//  TagsSection + Model.swift
//  List
//
//  Created by Anton Cherkasov on 08.02.2026.
//

import Foundation

extension TagsSection {

	@Observable
	final class Model {

		var includedTags: Set<UUID>

		var excludedTags: Set<UUID>

		// MARK: - Initialization

		init(includedTags: Set<UUID>, excludedTags: Set<UUID>) {
			self.includedTags = includedTags
			self.excludedTags = excludedTags
		}
	}
}

import SwiftUI

// MARK: - Public Interface
extension TagsSection.Model {

	func onTap(tag: UUID) {
		switch (includedTags.contains(tag), excludedTags.contains(tag)) {
		case (true, false):
			includedTags.remove(tag)
			excludedTags.insert(tag)
		case (false, true):
			excludedTags.remove(tag)
		default:
			includedTags.insert(tag)
		}
	}

	func state(for tag: UUID) -> TagState {
		if excludedTags.contains(tag) {
			return .excluded
		}
		if includedTags.contains(tag) {
			return .active
		}
		return .normal
	}

	func isOn(for tag: UUID) -> Binding<Bool> {
		return Binding {
			self.includedTags.contains(tag)
		} set: { newValue in
			if newValue {
				self.includedTags.insert(tag)
			} else {
				self.includedTags.remove(tag)
			}
		}
	}
}
