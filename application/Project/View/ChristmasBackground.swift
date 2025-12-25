//
//  ChristmasBackground.swift
//  Project
//
//  Created by Даниил on 24.12.2025.
//
import SwiftUI

struct ChristmasBackground: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> ChristmasBackgroundView {
        return ChristmasBackgroundView()
    }

    func updateUIView(_ uiView: ChristmasBackgroundView, context: Context) {
        uiView.updateGradientColors()
    }
}
