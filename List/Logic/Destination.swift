//
//  Destination.swift
//  List
//
//  Created by Anton Cherkasov on 15.02.2026.
//

import Foundation

enum Destination<ID: Hashable> {
	case before(id: ID)
	case after(id: ID)
}

extension Destination {

	var id: ID {
		switch self {
		case let .before(id):
			return id
		case let .after(id):
			return id
		}
	}
}
