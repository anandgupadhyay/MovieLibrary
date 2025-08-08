
//
//  MoviesViewModel.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//


import Foundation
import Combine


final class MoviesViewModel: ObservableObject {
    @Published var categories: [Category] = []

    @Published var draggingMovieID: UUID? = nil
    @Published var activeDropCategoryID: UUID? = nil
    @Published var selectedCategoryID: UUID? = nil
    @Published var selectedMovie: Movie? = nil

    @Published var draggingCategoryID: UUID? = nil

    init() {
        categories = [
            Category(id: UUID(), name: "All Movies", movies: [
                Movie(id: UUID(), title: "Edge of Tomorrow", iconName: "film"),
                Movie(id: UUID(), title: "Inception", iconName: "film.fill"),
                Movie(id: UUID(), title: "The Notebook", iconName: "heart"),
                Movie(id: UUID(), title: "Scary Night", iconName: "moon.stars"),
                Movie(id: UUID(), title: "Funny Bones", iconName: "face.smiling")
            ]),
            Category(id: UUID(), name: "Horror", movies: [
                Movie(id: UUID(), title: "Ghost House", iconName: "bolt"),
                Movie(id: UUID(), title: "Silent Hill", iconName: "eye")
            ]),
            Category(id: UUID(), name: "Romance", movies: [
                Movie(id: UUID(), title: "Love in Paris", iconName: "heart.fill")
            ]),
            Category(id: UUID(), name: "Comedy", movies: [
                Movie(id: UUID(), title: "Laugh Riot", iconName: "face.smiling"),
                Movie(id: UUID(), title: "Inception", iconName: "film")
            ]),
            Category(id: UUID(), name: "Thriller", movies: [])
        ]
    }

    // MARK: - Movies
    func addMovie(_ movie: Movie, toCategoryID id: UUID) {
        guard let index = categories.firstIndex(where: { $0.id == id }) else { return }
        categories[index].movies.append(movie)
    }

    func removeMovie(_ movie: Movie, fromCategoryID id: UUID) {
        guard let index = categories.firstIndex(where: { $0.id == id }) else { return }
        categories[index].movies.removeAll { $0.id == movie.id }
    }

    func moveMovie(_ movieID: UUID, toCategory targetID: UUID) {
        for cat in categories {
            if let movie = cat.movies.first(where: { $0.id == movieID }) {
                removeMovie(movie, fromCategoryID: cat.id)
                addMovie(movie, toCategoryID: targetID)
                return
            }
        }
    }

    func deleteMovie(with id: UUID) {
        for idx in categories.indices {
            if let movie = categories[idx].movies.first(where: { $0.id == id }) {
                categories[idx].movies.removeAll { $0.id == movie.id }
                return
            }
        }
    }

    // MARK: - Category reorder
    func indexOfCategory(_ id: UUID) -> Int? {
        categories.firstIndex(where: { $0.id == id })
    }

    func moveCategory(sourceID: UUID, before targetID: UUID) {
        guard let from = indexOfCategory(sourceID),
              let to = indexOfCategory(targetID),
              from != to else { return }
        let item = categories.remove(at: from)
        let insertIndex = from < to ? to - 1 : to
        categories.insert(item, at: insertIndex)
    }

    // MARK: - Derived
    var selectedCategory: Category? {
        guard let id = selectedCategoryID else { return nil }
        return categories.first(where: { $0.id == id })
    }
}
