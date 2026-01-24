//
//  IconName.swift
//  List
//
//  Created by Anton Cherkasov on 21.01.2026.
//

import Foundation

enum IconName: Int {

	case none = 0

	case bolt
	case star
	case sparkles
	case heart
	case calendar
	case mail
	case archivebox
	case creditcard
	case sunMax
}

// MARK: - CaseIterable
extension IconName: CaseIterable { }

// MARK: - Identifiable
extension IconName: Identifiable {

	var id: RawValue {
		rawValue
	}
}

// MARK: - Computed Properties
extension IconName {

	var imageName: String? {
		switch self {
		case .none:
			return nil
		case .bolt:
			return "bolt"
		case .star:
			return "star"
		case .sparkles:
			return "sparkles"
		case .heart:
			return "heart"
		case .calendar:
			return "calendar"
		case .mail:
			return "envelope"
		case .archivebox:
			return "archivebox"
		case .creditcard:
			return "creditcard"
		case .sunMax:
			return "sun.max"
		}
	}
}
