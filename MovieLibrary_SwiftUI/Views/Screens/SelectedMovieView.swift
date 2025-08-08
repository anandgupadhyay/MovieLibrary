
//
//  SelectedMovieView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//


import SwiftUI

struct SelectedMovieView: View {
    let movie: Movie

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: movie.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)

            Text(movie.title)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding(24)
        .navigationTitle("Movie")
        .navigationBarTitleDisplayMode(.inline)
    }
}
