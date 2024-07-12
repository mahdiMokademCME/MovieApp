//
//  MovieDetailsDTO.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation

struct MovieDetailsDTO {
    var collection: BelongsToCollection?
    var genres: [Genre]?
    let id: Int
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let backdropPath: URL?
    let releaseDate: String?
    let spokenLanguages: [SpokenLanguage]?
    let voteAverage: Double?
    let voteCount: Int?
}
