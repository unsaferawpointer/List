//
//  IconName.swift
//  List
//
//  Created by Anton Cherkasov on 21.01.2026.
//

import Foundation

enum IconName: Int {
	case none
	case bolt
	case star
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
		}
	}
}
