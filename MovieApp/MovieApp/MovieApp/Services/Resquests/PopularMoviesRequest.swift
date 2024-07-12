//
//  PopularMoviesRequest.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation

class PopularMoviesRequest: APIRequest<MoviesList> {
    
    init(page: Int) {
        super.init(url: .popularMovies(page: page), methode: .get, responseObjectType: MoviesList.self, params: nil, headers: nil, authentication: true, interceptor: false)
    }
    
}
