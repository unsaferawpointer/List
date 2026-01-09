//
//  Status.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import Foundation

enum Status: UInt8 {
	case incomplete = 0
	case done
}

// MARK: - Codable
extension Status: Codable { }

extension Status: Comparable {

	static func < (lhs: Status, rhs: Status) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}
