//
//  TagView.swift
//  List
//
//  Created by Anton Cherkasov on 26.01.2026.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

// MARK: - SwiftUI View для тега с контекстным меню
struct TagView: UIViewRepresentable {

	let title: String

	var foregroundColor: UIColor = .systemBlue
	var backgroundColor: UIColor = .systemBlue

	var imageName: String
	let menuItems: [UIAction]

	var action: (() -> Void)?

	func makeUIView(context: Context) -> UIButton {
		let button = UIButton(type: .roundedRect)
		button.configuration = buildConfiguration()
		button.menu = UIMenu(title: "", children: menuItems)
		button.showsMenuAsPrimaryAction = false
		button.addTarget(
			context.coordinator,
			action: #selector(Coordinator.buttonTapped(_:)),
			for: .touchUpInside
		)

		context.coordinator.action = action
		return button
	}

	func updateUIView(_ uiView: UIButton, context: Context) {
		uiView.configuration = buildConfiguration()
		context.coordinator.action = action
		uiView.menu = UIMenu(title: "", children: menuItems)
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	class Coordinator {

		var action: (() -> Void)?

		@objc func buttonTapped(_ sender: UIButton) {
			action?()
		}
	}
}

// MARK: - Helpers
private extension TagView {

	func buildConfiguration() -> UIButton.Configuration {
		var configuration = UIButton.Configuration.bordered()
		configuration.title = title
		configuration.image = UIImage(systemName: imageName)
		configuration.baseForegroundColor = foregroundColor
		configuration.baseBackgroundColor = backgroundColor
		configuration.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
		configuration.cornerStyle = .capsule
		configuration.imagePadding = 6
		configuration.buttonSize = .mini
		return configuration
	}
}
#endif
