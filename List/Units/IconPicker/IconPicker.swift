//
//  IconNamePicker.swift
//  List
//
//  Created by Anton Cherkasov on 24.01.2026.
//

import SwiftUI

#if os(iOS)
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
		}
		.frame(width: 80)
	}
}
#endif

#if os(macOS)
struct IconPicker: View {

	@State var icons: [IconName] = IconName.allCases

	var onTap: (IconName) -> Void

	// MARK: - Initialization

	init(onTap: @escaping (IconName) -> Void) {
		self.onTap = onTap
	}

	var body: some View {
		ForEach(icons) { icon in
			Button {
				onTap(icon)
			} label: {
				Label(icon.imageName ?? "None", systemImage: icon.imageName ?? "circle.slash")
			}
		}
	}
}


#Preview {
	IconPicker { icon in

	}
}
#endif
