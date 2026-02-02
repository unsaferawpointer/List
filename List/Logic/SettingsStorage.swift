//
//  SettingsStorage.swift
//  List
//
//  Created by Anton Cherkasov on 02.02.2026.
//

import Foundation

final class SettingsStorage {

	private let defaults: UserDefaults

	// MARK: - Initialization

	init(defaults: UserDefaults = .standard) {
		self.defaults = defaults
	}
}

extension SettingsStorage {

	func loadFilter() -> Filter {
		guard let data = defaults.data(forKey: "filter") else {
			return Filter()
		}

		let decoder = JSONDecoder()

		do {
			return try decoder.decode(Filter.self, from: data)
		} catch {
			return Filter()
		}
	}
}

extension SettingsStorage {

	func saveFilter(_ filter: Filter) {
		let encoder = JSONEncoder()
		do {
			let data = try encoder.encode(filter)
			defaults.set(data, forKey: "filter")
		} catch {

		}
	}
}
