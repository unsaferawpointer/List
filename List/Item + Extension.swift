//
//  Item + Extension.swift
//  List
//
//  Created by Anton Cherkasov on 09.01.2026.
//

import SwiftUI

extension Item {

	var isOn: Binding<Bool> {
		Binding {
			self.isCompleted
		} set: { newValue in
			self.isCompleted = newValue
		}
	}
}
