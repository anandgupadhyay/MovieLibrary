
//
//  ContentView.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var vm = MoviesViewModel()
    @Namespace private var ns

    @State private var path = NavigationPath()

    private let horizontalPadding: CGFloat = 20
    private let interColumnSpacing: CGFloat = 10

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(vm.categories) { category in
                            CategoryCardView(
                                viewModel: vm,
                                category: category,
                                namespace: ns,
                                horizontalPadding: horizontalPadding,
                                interColumnSpacing: interColumnSpacing
                            )
                        }
                    }
                    .padding(.horizontal, horizontalPadding / 2)
                    .padding(.vertical, 16)
                }

                if let selected = vm.selectedCategory {
                    Color.black.opacity(0.15)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    CategoryDetailOverlay(
                        viewModel: vm,
                        category: selected,
                        namespace: ns,
                        onClose: { vm.selectedCategoryID = nil }
                    )
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                            removal: .opacity))
                    .zIndex(2)
                }

                if vm.draggingMovieID != nil && vm.selectedCategoryID == nil {
                    VStack {
                        Spacer()
                        DeleteDropZone { movieID in
                            vm.deleteMovie(with: movieID)
                            vm.draggingMovieID = nil
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: vm.draggingMovieID != nil)
            .navigationTitle("Movie Board")

            .navigationDestination(for: Movie.self) { movie in
                SelectedMovieView(movie: movie)
            }

            .onChange(of: vm.selectedMovie) { m in
                if let m {
                    path.append(m)
                    vm.selectedMovie = nil  
                }
            }
        }
    }
}
