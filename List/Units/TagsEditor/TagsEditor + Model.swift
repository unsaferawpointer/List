//
//  TagsEditor + Model.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import Foundation
import SwiftData

#if os(iOS)

extension TagsEditor {

	final class Model {

	}
}

import SwiftUI

extension TagsEditor.Model {

	func addTag(with name: String, iconName: IconName, to modelContext: ModelContext, allTags: [Tag]) {
		let newTag = Tag(title: name)
		newTag.iconName = iconName
		newTag.index = (allTags.last?.index ?? 0) + 1
		modelContext.insert(newTag)
	}

	func moveTags(_ tags: [Tag], indices: IndexSet, to target: Int) {
		var modificated = tags
		modificated.move(fromOffsets: indices, toOffset: target)
		for (index, tag) in modificated.enumerated() {
			tag.index = index
		}
	}

	func deleteTags(selected: Set<PersistentIdentifier>, in modelContext: ModelContext) {
		try? modelContext.transaction {
			for id in selected {
				guard let tag = modelContext.model(for: id) as? Tag else {
					continue
				}
				modelContext.delete(tag)
			}
		}
	}
}
#endif
