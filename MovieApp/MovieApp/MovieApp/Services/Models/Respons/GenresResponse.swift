//
//  GenresResponse.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation

// MARK: - GenresList
struct GenresList: Codable {
    let genres: [Genre]
}

// MARK: - Genre
struct Genre: Codable, Hashable, Equatable {
    let id: Int
    let name: String
}
