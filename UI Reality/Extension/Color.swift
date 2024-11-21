//
//  Color.swift
//  UI Reality
//
//  Created by Pardn on 2024/11/21.
//

import SwiftUI;

extension Color {

	init(rgb red: Int,_ green: Int,_ blue: Int) {
		self.init(
			.sRGB,
			red: Double(red) / 255.0,
			green: Double(green) / 255.0,
			blue: Double(blue) / 255.0,
			opacity: 1
		);
	};

	init(rgba red: Int,_ green: Int,_ blue: Int,_ opacity: Double = 1.0) {
		self.init(
			.sRGB,
			red: Double(red) / 255.0,
			green: Double(green) / 255.0,
			blue: Double(blue) / 255.0,
			opacity: opacity
		);
	};

	init(hex: String) {
		var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines);
		hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "");

		var rgb: UInt64 = 0
		Scanner(string: hexSanitized).scanHexInt64(&rgb);

		let red, green, blue, opacity: Double;

		if hexSanitized.count == 8 {
			red = Double((rgb >> 24) & 0xFF) / 255;
			green = Double((rgb >> 16) & 0xFF) / 255;
			blue = Double((rgb >> 8) & 0xFF) / 255;
			opacity = Double(rgb & 0xFF) / 255;
		}
		else if hexSanitized.count == 6 {
			red = Double((rgb >> 16) & 0xFF) / 255;
			green = Double((rgb >> 8) & 0xFF) / 255;
			blue = Double(rgb & 0xFF) / 255;
			opacity = 1;
		}
		else {
			red = 1;
			green = 1;
			blue = 1;
			opacity = 1;
		}

		self.init(
			.sRGB,
			red: red,
			green: green,
			blue: blue,
			opacity: opacity
		)
	}
};
