//
//  ContentModel.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import Foundation

final class ContentModel {

}

extension ContentModel {

	func shouldDisplayEditButton(for items: [Item]) -> Bool {
		return !items.isEmpty
	}
}
