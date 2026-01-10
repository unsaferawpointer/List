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
		.modelContainer(for: [Item.self], inMemory: false, isAutosaveEnabled: true, isUndoEnabled: true) { result in
			switch result {
			case let .success(container):
				break
			case .failure:
				break
			}
		}
	}
}
