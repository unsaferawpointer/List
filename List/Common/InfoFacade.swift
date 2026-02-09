//
//  InfoFacade.swift
//  List
//
//  Created by Anton Cherkasov on 09.02.2026.
//

import Foundation

final class InfoFacade { }

extension InfoFacade {

	static var currentVersion: String? {
		Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
	}
}
