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

		let schema = Schema([Tag.self])
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

			let tagsText = Loader.loadTextFileFromBundle(filename: "PreviewTags", withExtension: "txt")
			tagsText?.enumerateLines { line, stop in
				let tag = Tag(title: line)
				context.insert(tag)
			}

			return container
		} catch {
			fatalError("Не удалось создать ModelContainer: \(error)")
		}
	}()
}
