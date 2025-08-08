
//
//  MovieTileView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//

import SwiftUI

struct MovieTileView: View {
    let movie: Movie
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                Image(systemName: movie.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            Text(movie.title)
                .font(.caption)
                .lineLimit(1)
                .frame(maxWidth: 100)
        }
        .frame(width: 110)
    }
}
