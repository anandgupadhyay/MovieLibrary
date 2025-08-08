//
//  OthersSmallTileView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//

import SwiftUI

struct OthersSmallTileView: View {
    let sampleIcons: [String]
    let count: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let mini = size * 0.36  
                let offset = size * 0.18

                ZStack {
                    if sampleIcons.indices.contains(0) {
                        icon(sampleIcons[0], mini)
                            .offset(x: -offset, y: -offset)
                    }
                    if sampleIcons.indices.contains(1) {
                        icon(sampleIcons[1], mini)
                            .offset(x: offset, y: -offset)
                    }
                    if sampleIcons.indices.contains(2) {
                        icon(sampleIcons[2], mini)
                            .offset(x: -offset, y: offset)
                    }
                    if sampleIcons.indices.contains(3) {
                        icon(sampleIcons[3], mini)
                            .offset(x: offset, y: offset)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        }
        .accessibilityLabel(Text("Others"))
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func icon(_ name: String, _ size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .frame(width: size, height: size)

            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.55, height: size * 0.55)
                .foregroundColor(.primary)
        }
    }
}
