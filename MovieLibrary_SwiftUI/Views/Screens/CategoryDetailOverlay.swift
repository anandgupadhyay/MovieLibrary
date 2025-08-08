
//
//  CategoryDetailOverlay.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//

import SwiftUI

struct CategoryDetailOverlay: View {
    @ObservedObject var viewModel: MoviesViewModel
    var category: Category
    var namespace: Namespace.ID
    var onClose: () -> Void

    let horizontalPadding: CGFloat = 20
    let spacing: CGFloat = 10

    private var columnsInsideCard: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: spacing), count: 3)
    }

    var body: some View {
        GeometryReader { geo in
            let iconSize = (geo.size.width - (horizontalPadding * 2) - (spacing * 2)) / 3

            VStack(spacing: 0) {
                HStack {
                    Text(category.name)
                        .font(.system(size: 36, weight: .bold))
                        .matchedGeometryEffect(id: "title-\(category.id.uuidString)", in: namespace)
                        .padding(.leading, 16)

                    Spacer()

                    Button(action: onClose) {
                        ZStack {
                            Circle()
                                .fill(Color(.systemBackground).opacity(0.95))
                                .frame(width: 40, height: 40)
                                .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 6)

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: geo.size.width - 32, height: geo.size.width - 32)
                        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                        .matchedGeometryEffect(id: "card-\(category.id.uuidString)", in: namespace)

                    LazyVGrid(columns: columnsInsideCard, spacing: spacing) {
                        ForEach(category.movies, id: \.id) { movie in
                            VStack {
                                Image(systemName: movie.iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: iconSize, height: iconSize)

                                Text(movie.title)
                                    .font(.caption2)
                                    .lineLimit(1)
                            }
                            .onTapGesture { viewModel.selectedMovie = movie }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 20)
                }
                .padding(.top, 8)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear.ignoresSafeArea())
        }
    }
}
