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

	let sharedContainer = CommonStorage.shared.container

//	let sharedContainer = PreviewContainer.previewContainer

	#if os(iOS)
	@State private var isOnboardingShown: Bool = false
	#elseif os(macOS)
	@Environment(\.openWindow) private var openWindow
	#endif

	var body: some Scene {

		#if os(macOS)
		Window("List", id: "welcome") {
			OnboardingView(model: OnboardingModelFactory.makeModel()) {
				openWindow(id: "main")
			}
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
		#endif

		WindowGroup(id: "main") {
			ContentView()
				.modelContainer(sharedContainer)
				#if os(iOS)
				.onAppear {
					isOnboardingShown = onboardingShownForVersion != InfoFacade.currentVersion
				}
				.fullScreenCover(isPresented: $isOnboardingShown) {
					OnboardingView(model: OnboardingModelFactory.makeModel()) {
						onboardingShownForVersion = InfoFacade.currentVersion
					}
					.interactiveDismissDisabled()
				}
				#endif
		}
		.commands {
			EditorCommands()
		}
		#if os(macOS)
		.defaultLaunchBehavior(onboardingShownForVersion == InfoFacade.currentVersion ? .presented : .suppressed)
		#endif


		#if os(macOS)
		Settings {
			SettingsView()
		}
		.modelContainer(sharedContainer)
		#endif
	}
}
