//
//  PreviewContainer.swift
//  List
//
//  Created by Anton Cherkasov on 31.01.2026.
//

import Foundation
import SwiftData

final class PreviewContainer {

	static let previewContainer: ModelContainer = {

		let schema = Schema([Item.self, Tag.self])
		let configuration = ModelConfiguration(
			nil,
			schema: schema,
			isStoredInMemoryOnly: true,
			allowsSave: true,
			groupContainer: .automatic,
			cloudKitDatabase: .none
		)

		do {
			let container = try ModelContainer(for: schema, configurations: [configuration])

			// Добавляем тестовые данные
			let context = container.mainContext

			let itemsData: [(text: String, tags: [String])] = [
				("Clean the kitchen", ["Home"]),
				("Do the laundry", ["Home"]),
				("Take out the trash", ["Home"]),
				("Pay monthly bills", ["Finance"]),
				("Grocery shopping", ["Errands"]),
				("Water the plants", ["Home"]),
				("Plan meals for the week", ["Home", "Health"]),
				("Go for a 30-minute walk", ["Health"]),
				("Call a family member", ["Family"]),
				("Organize photos on the phone", ["Errands"])
			]

			var tagsByTitle: [String: Tag] = [:]
			var nextTagIndex = 0

			func tag(for title: String) -> Tag {
				if let existingTag = tagsByTitle[title] {
					return existingTag
				}

				let newTag = Tag(title: title, index: nextTagIndex)
				nextTagIndex += 1
				tagsByTitle[title] = newTag
				context.insert(newTag)
				return newTag
			}

			for (index, itemData) in itemsData.enumerated() {
				let item = Item(text: itemData.text, index: index)
				item.tags = itemData.tags.map(tag(for:))
				context.insert(item)
			}

			try context.save()

			return container
		} catch {
			fatalError("Не удалось создать ModelContainer: \(error)")
		}
	}()
}
