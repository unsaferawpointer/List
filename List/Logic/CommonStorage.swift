//
//  CommonStorage.swift
//  List
//
//  Created by Anton Cherkasov on 14.02.2026.
//

import SwiftData

protocol DataStorage {
	static var shared: DataStorage { get }
	var container: ModelContainer { get }
}

final class CommonStorage: DataStorage {

	static var shared: DataStorage = CommonStorage()

	lazy var container: ModelContainer = {
		let schema = Schema([Item.self, Tag.self])
		let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

		do {
			return try ModelContainer(for: schema, configurations: [configuration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()

	// MARK: - Initialization

	private init() { }
}
