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

	var timestamp: Date

	var text: String

	var isCompleted: Bool

	var index: Int

	// MARK: - Initialization

	init(timestamp: Date = .now, text: String, isCompleted: Bool = false, index: Int = 0) {
		self.timestamp = timestamp
		self.text = text
		self.isCompleted = isCompleted
		self.index = index
	}
}
