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
		])
		let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

		do {
			let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
			if let text = Loader().loadTextFileFromBundle(filename: "PreviewItems", withExtension: "txt") {
				text.enumerateLines { line, stop in
					let new = Item(text: line)
					container.mainContext.insert(new)
				}
			}
			return container
		} catch {
			fatalError("Could not create ModelContainer: \(error)")
		}
	}()

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(sharedModelContainer)
	}
}
