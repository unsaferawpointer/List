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

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
		.modelContainer(for: [Item.self], inMemory: true, isAutosaveEnabled: true, isUndoEnabled: true) { result in
			switch result {
			case let .success(container):
				if let text = Loader().loadTextFileFromBundle(filename: "PreviewItems", withExtension: "txt") {
					text.enumerateLines { line, stop in
						let new = Item(text: line)
						container.mainContext.insert(new)
					}
				}
			case .failure:
				break
			}
		}
	}
}
