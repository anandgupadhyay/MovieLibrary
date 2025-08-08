
//
//  CategoryCardView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//

import SwiftUI

struct CategoryCardView: View {
    @ObservedObject var viewModel: MoviesViewModel
    var category: Category
    var namespace: Namespace.ID
    var horizontalPadding: CGFloat = 20
    var interColumnSpacing: CGFloat = 10

    @State private var isTargeted = false
    @State private var catLongPressed = false

    private var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth / 2) - horizontalPadding - interColumnSpacing
    }

    private var smallTileSize: CGFloat {
        let internalPadding: CGFloat = 16
        let gridSpacing: CGFloat = 12
        let available = cardWidth - (internalPadding * 2) - gridSpacing
        return available / 2
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(isTargeted ? .blue : .clear, lineWidth: 2)
                            .animation(.easeInOut(duration: 0.15), value: isTargeted)
                    )
                    .frame(width: cardWidth, height: cardWidth)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    .matchedGeometryEffect(id: "card-\(category.id.uuidString)", in: namespace)

                if isTargeted {
                    VStack {
                        Text("Drop into \(category.name)")
                            .font(.footnote)
                            .padding(6)
                            .background(.ultraThinMaterial, in: Capsule())
                        Spacer().frame(height: 6)
                    }
                    .transition(.opacity.combined(with: .scale))
                }

                let movies = category.movies
                let firstThree = Array(movies.prefix(3))
                let remainingCount = max(0, movies.count - 3)

                VStack {
                    LazyVGrid(columns: [
                        GridItem(.fixed(smallTileSize), spacing: 12),
                        GridItem(.fixed(smallTileSize), spacing: 12)
                    ], spacing: 12) {

                        ForEach(firstThree.prefix(2), id: \.id) { movie in
                            MovieSmallTileView(movie: movie, viewModel: viewModel)
                                .frame(width: smallTileSize, height: smallTileSize)
                        }

                        if firstThree.count >= 3 {
                            MovieSmallTileView(movie: firstThree[2], viewModel: viewModel)
                                .frame(width: smallTileSize, height: smallTileSize)
                        } else {
                            PlaceholderSmallTileView()
                                .frame(width: smallTileSize, height: smallTileSize)
                        }

                        if remainingCount > 0 {
                            OthersSmallTileView(
                                sampleIcons: Array(movies.dropFirst(3).prefix(4)).map { $0.iconName },
                                count: remainingCount
                            )
                            .frame(width: smallTileSize, height: smallTileSize)
                            .onTapGesture {
                                viewModel.selectedCategoryID = category.id
                            }
                        } else {
                            PlaceholderSmallTileView()
                                .frame(width: smallTileSize, height: smallTileSize)
                        }
                    }
                    .padding(16)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectedCategoryID = category.id
            }

            .simultaneousGesture(
                LongPressGesture(minimumDuration: 1.0)
                    .onEnded { _ in
                        catLongPressed = true
                        viewModel.draggingCategoryID = category.id
                    }
            )
            .modifier(DraggableWhenEnabled(enabled: catLongPressed, payload: category.id.uuidString))

            .dropDestination(for: String.self) { items, _ in
                guard let sourceIDString = items.first,
                      let sourceUUID = UUID(uuidString: sourceIDString) else { return false }

                if viewModel.categories.contains(where: { $0.id == sourceUUID }) {
                    viewModel.moveCategory(sourceID: sourceUUID, before: category.id)
                    viewModel.draggingCategoryID = nil
                    catLongPressed = false
                } else {
                    viewModel.moveMovie(sourceUUID, toCategory: category.id)
                }
                viewModel.activeDropCategoryID = nil
                return true
            } isTargeted: { hovering in
                isTargeted = hovering
                viewModel.activeDropCategoryID = hovering ? category.id : nil
            }
            .scaleEffect(isTargeted ? 1.02 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: isTargeted)
            .onDisappear {
                if viewModel.draggingCategoryID == category.id { viewModel.draggingCategoryID = nil }
                catLongPressed = false
            }

            Text(category.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
                .frame(width: cardWidth)
                .multilineTextAlignment(.center)
                .matchedGeometryEffect(id: "title-\(category.id.uuidString)", in: namespace)
        }
        .frame(width: cardWidth)
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
