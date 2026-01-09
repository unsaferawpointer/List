//
//  Tag.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import Foundation
import SwiftData

@Model
final class Tag {

	@Attribute(.unique) var uuid: UUID

	var timestamp: Date

	var title: String

	var index: Int

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify)
	var items: [Item] = []

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		timestamp: Date = .now,
		title: String,
		index: Int = 0
	) {
		self.uuid = uuid
		self.timestamp = timestamp
		self.title = title
		self.index = index
	}
}
