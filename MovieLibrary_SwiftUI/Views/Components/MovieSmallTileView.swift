
//
//  MovieSmallTileView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//


import SwiftUI

struct MovieSmallTileView: View {
    let movie: Movie
    @ObservedObject var viewModel: MoviesViewModel

    @State private var longPressed = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )

            Image(systemName: movie.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundColor(.primary)
        }
        .contentShape(Rectangle()) // ensure full tile is tappable

        .onTapGesture {
            viewModel.selectedMovie = movie
        }

        .simultaneousGesture(
            LongPressGesture(minimumDuration: 1.0)
                .onEnded { _ in
                    longPressed = true
                    viewModel.draggingMovieID = movie.id
                }
        )
        .modifier(DraggableWhenEnabled(enabled: longPressed, payload: movie.id.uuidString))

        .onDisappear {
            if viewModel.draggingMovieID == movie.id { viewModel.draggingMovieID = nil }
            longPressed = false
        }
    }
}

private struct DraggableWhenEnabled: ViewModifier {
    let enabled: Bool
    let payload: String
    func body(content: Content) -> some View {
        if enabled {
            content.draggable(payload)
        } else {
            content
        }
    }
}
