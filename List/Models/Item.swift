//
//  Item.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class Item {

	var uuid: UUID = UUID()

	var timestamp: Date = Date(timeIntervalSince1970: 0)

	var text: String = ""

	var rawStatus: UInt8 = 0

	var index: Int = 0

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify, inverse: \Tag.items)
	var tags: [Tag]? = []

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		timestamp: Date = .now,
		text: String,
		rawStatus: UInt8 = Status.incomplete.rawValue,
		index: Int = 0
	) {
		self.uuid = uuid
		self.timestamp = timestamp
		self.text = text
		self.rawStatus = rawStatus
		self.index = index
	}
}

// MARK: - Computed Properties
extension Item {

	var isCompleted: Bool {
		get {
			Status(rawValue: rawStatus) != .incomplete
		}
		set {
			rawStatus = newValue ? Status.done.rawValue : Status.incomplete.rawValue
		}
	}
}
