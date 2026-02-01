//
//  Loader.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import Foundation

final class Loader {

	static func loadTextFileFromBundle(filename: String, withExtension: String) -> String? {
		guard let fileURL = Bundle.main.url(forResource: filename, withExtension: withExtension) else {
			return nil
		}

		do {
			let content = try String(contentsOf: fileURL, encoding: .utf8)
			return content
		} catch {
			return nil
		}
	}
}
