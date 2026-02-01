//
//  SortDescriptor + Extension.swift
//  List
//
//  Created by Anton Cherkasov on 01.02.2026.
//

import Foundation

extension SortDescriptor where Compared == Tag {

	static var byIndex: SortDescriptor<Compared> {
		SortDescriptor(\.index, order: .forward)
	}

	static var byTimestamp: SortDescriptor<Compared> {
		SortDescriptor(\.timestamp, order: .forward)
	}
}

extension SortDescriptor where Compared == Item {

	static var byIndex: SortDescriptor<Compared> {
		SortDescriptor(\.index, order: .forward)
	}

	static var byTimestamp: SortDescriptor<Compared> {
		SortDescriptor(\.timestamp, order: .forward)
	}
}
