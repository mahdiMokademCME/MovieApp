//
//  MoviesRepositoryRealImplementation.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation

/*This is the actual implementation of the MoviesRepository that hits the real endpoint.
 Later on, we can add a mock implementation and activate it for testing,
 this will help manipulate the data and test the app with different responses.
 A mock implementation will not hit the real endpoints,
 however it can return the data from local json files.*/

class MoviesRepositoryRealImplementation: MoviesRepository {
    
    func getDetails(id: Int) async throws -> MovieDetailsResponse {
        let api = MovieDetailsRequest(id: id)
        do {
            let response = try await api.request()
            return response
        } catch {
            throw error
        }
    }
    
    func genres() async throws -> GenresList {
        let api = GenresRequest()
        do {
            let response = try await api.request()
            return response
        } catch {
            throw error
        }
    }

    func popularMovies(page: Int) async throws -> MoviesList {
        let popularMoviesAPI = PopularMoviesRequest(page: page)
        do {
            let response = try await popularMoviesAPI.request()
            return response
        } catch {
            throw error
        }
    }
}
