
//
//  Models.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//


import Foundation

struct Movie: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var iconName: String
}

struct Category: Identifiable, Hashable {
    let id: UUID
    var name: String
    var movies: [Movie]
}
