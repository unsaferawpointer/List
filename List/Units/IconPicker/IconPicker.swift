//
//  IconNamePicker.swift
//  List
//
//  Created by Anton Cherkasov on 24.01.2026.
//

import SwiftUI

struct IconPicker: View {

	@Binding var icon: IconName

	@Environment(\.dismiss) var dismiss

	@State var icons: [IconName] = IconName.allCases

	let columns = [GridItem(.adaptive(minimum: 80, maximum: 100), spacing: 16)]

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, spacing: 20) {
					ForEach(icons) { icon in
						IconNameCell(
							icon: icon,
							isSelected: self.icon.id == icon.id
						)
						.onTapGesture {
							self.icon = icon
							dismiss()
						}
					}
				}
				.padding()
			}
			.navigationTitle("Select icon")
		}
	}
}

struct IconNameCell: View {
	let icon: IconName
	let isSelected: Bool

	var body: some View {
		VStack(spacing: 8) {
			ZStack {
				Image(systemName: icon.imageName ?? "circle.slash")
					.resizable()
					.scaledToFit()
					.frame(width: 32, height: 32)
			}
			.frame(width: 60, height: 60)
			.background(isSelected ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.1))
			.cornerRadius(12)
			.overlay(
				RoundedRectangle(cornerRadius: 12)
					.stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
			)
//			Text("IconName")
//				.font(.caption2)
//				.multilineTextAlignment(.center)
//				.lineLimit(2)
//				.foregroundColor(isSelected ? .accentColor : .primary)
		}
		.frame(width: 80)
	}
}


#Preview {
	IconPicker(icon: .constant(.star))
}
