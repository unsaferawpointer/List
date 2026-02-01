//
//  TagView.swift
//  List
//
//  Created by Anton Cherkasov on 26.01.2026.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

// MARK: - UIViewRepresentable
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
#elseif os(macOS)
import AppKit

// MARK: - NSViewRepresentable
struct TagView: NSViewRepresentable {

	let title: String

	let foregroundColor: NSColor

	var imageName: String

	var isOn: Bool

	var onTap: (() -> Void)?

	var onExclude: (() -> Void)?

	func makeNSView(context: Context) -> NSButton {
		let button = NSButton()
		configure(button)
		button.action = #selector(Coordinator.buttonTapped(_:))
		button.target = context.coordinator

		button.menu = {
			let menu = NSMenu()
			menu.addItem(
				{
					let item = NSMenuItem()
					item.title = "Exclude"
					item.action = #selector(Coordinator.excludeButtonTapped)
					item.image = NSImage(systemSymbolName: "xmark.circle", accessibilityDescription: nil)
					item.target = context.coordinator
					return item
				}()
			)
			return menu
		}()

		context.coordinator.action = onTap
		context.coordinator.onExclude = onExclude
		return button
	}

	func updateNSView(_ nsView: NSButton, context: Context) {
		configure(nsView)

		context.coordinator.action = onTap
		context.coordinator.onExclude = onExclude
	}

	func makeCoordinator() -> Coordinator {
		Coordinator()
	}

	class Coordinator {

		var action: (() -> Void)?

		var onExclude: (() -> Void)?

		@objc func buttonTapped(_ sender: NSButton) {
			action?()
		}

		@objc func excludeButtonTapped(_ sender: NSMenuItem) {
			onExclude?()
		}
	}
}

// MARK: - Helpers
private extension TagView {

	func configure(_ button: NSButton) {
		button.title = title
		button.image = NSImage(systemSymbolName: imageName, accessibilityDescription: nil)
		button.imagePosition = .imageLeading
		button.bezelStyle = .accessoryBar
		button.bezelColor = foregroundColor
		button.borderShape = .capsule
		button.isBordered = true
		button.setButtonType(.pushOnPushOff)
		button.tintProminence = .none

		button.state = isOn ? .on : .off
	}
}
#endif
