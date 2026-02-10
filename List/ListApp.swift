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

	@AppStorage("onboardingShownForVersion") private var onboardingShownForVersion: String?

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

		Window("List", id: "welcome") {
			OnboardingView(model: OnboardingModelFactory.makeModel())
				.onDisappear {
					onboardingShownForVersion = InfoFacade.currentVersion
				}
				.windowMinimizeBehavior(.disabled)
				.windowResizeBehavior(.disabled)
				.windowFullScreenBehavior(.disabled)
		}
		.windowStyle(.hiddenTitleBar)
		.defaultSize(width: 560, height: 680)
		.defaultLaunchBehavior(onboardingShownForVersion == InfoFacade.currentVersion ? .suppressed : .presented)

		WindowGroup(id: "main") {
			ContentView()
				.modelContainer(sharedModelContainer)
		}
		.defaultLaunchBehavior(onboardingShownForVersion == InfoFacade.currentVersion ? .presented : .suppressed)


		#if os(macOS)
		Settings {
			SettingsView()
		}
		.modelContainer(sharedModelContainer)
		#endif
	}
}

