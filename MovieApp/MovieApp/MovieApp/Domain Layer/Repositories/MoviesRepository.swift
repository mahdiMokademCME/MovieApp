//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation

protocol MoviesRepository {
    func popularMovies(page: Int) async throws -> MoviesList
    func genres() async throws -> GenresList
    func getDetails(id: Int) async throws -> MovieDetailsResponse
}
