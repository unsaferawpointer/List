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

	var uuid: UUID = UUID()

	var timestamp: Date = Date(timeIntervalSince1970: 0)

	var title: String = ""

	var isHidden: Bool = false

	var index: Int = 0

	// MARK: - Raw Values

	private(set) var rawIcon: Int = 0

	// MARK: - Relationships

	@Relationship(deleteRule: .nullify)
	var items: [Item]? = []

	// MARK: - Initialization

	init(
		uuid: UUID = .init(),
		timestamp: Date = .now,
		title: String,
		isHidden: Bool = false,
		index: Int = 0,
		rawIcon: Int = 0
	) {
		self.uuid = uuid
		self.timestamp = timestamp
		self.title = title
		self.isHidden = isHidden
		self.index = index
		self.rawIcon = rawIcon
	}
}

// MARK: - Computed Properties
extension Tag {

	var iconName: IconName? {
		get {
			IconName(rawValue: rawIcon)
		}
		set {
			guard let newValue else {
				rawIcon = IconName.none.rawValue
				return
			}
			rawIcon = newValue.rawValue
		}
	}
}
