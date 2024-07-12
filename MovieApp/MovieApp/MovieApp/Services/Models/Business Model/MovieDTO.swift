//
//  MovieDTO.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation

struct MovieDTO: Hashable, Equatable {
    let uuid = UUID().uuidString
    let id: Int
    let posterURL: URL
    let title: String
    let genres: [Genre]
    let productionYear: String
}

struct MovieSection: Hashable {
    let type: MovieSectionType
    let movies: [MovieDTO]
}

enum MovieSectionType: Equatable {
    case top6
    case forYou
    case other
}
