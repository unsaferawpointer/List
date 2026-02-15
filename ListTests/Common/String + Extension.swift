//
//  String + Extension.swift
//  ListTests
//
//  Created by Anton Cherkasov on 15.02.2026.
//

import Foundation

extension String {

	static var random: String {
		UUID().uuidString
	}
}
