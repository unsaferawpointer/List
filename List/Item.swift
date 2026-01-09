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

	var rawStatus: UInt8

	var index: Int

	// MARK: - Initialization

	init(timestamp: Date = .now, text: String, rawStatus: UInt8 = Status.incomplete.rawValue, index: Int = 0) {
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
			Status(rawValue: rawStatus) == .done
		}
		set {
			rawStatus = newValue ? Status.done.rawValue : Status.incomplete.rawValue
		}
	}
}
