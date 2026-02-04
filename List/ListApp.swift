//
//  ListApp.swift
//  List
//
//  Created by Anton Cherkasov on 08.01.2026.
//

import SwiftUI
import SwiftData

@main
struct ListApp: App {

	var sharedModelContainer: ModelContainer = {
		let schema = Schema([
			Item.self,
			Tag.self
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

		do {
			return try ModelContainer(for: schema, configurations: [modelConfiguration])
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(sharedModelContainer)

		Settings {
			SettingsView()
		}
		.modelContainer(sharedModelContainer)
	}
}
