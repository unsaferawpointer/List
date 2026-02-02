//
//  Query + Extension.swift
//  List
//
//  Created by Anton Cherkasov on 02.02.2026.
//

import SwiftData
import SwiftUI

extension Query where Element == Tag, Result == [Tag] {

	static var all: Query<Tag, [Tag]> {
		Query(sort: [.byIndex, .byTimestamp], animation: .default)
	}
}

extension Query where Element == Item, Result == [Item] {

	static func concrete(ids: Set<PersistentIdentifier>) -> Query<Item, [Item]> {
		let predicate = #Predicate<Item> { item in
			ids.contains(item.id)
		}
		return Query(filter: predicate, animation: .default)
	}
}
