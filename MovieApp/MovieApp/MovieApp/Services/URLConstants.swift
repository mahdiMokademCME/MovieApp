//
//  URLConstants.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
enum URLConstants: CustomStringConvertible, Equatable {
    case popularMovies(page: Int)
    case genres
    case movieDetails(id: Int)
  
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

    var path: String {
        switch self {
        case .popularMovies(let page):
            return "discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=popularity.desc"
        case .genres:
            return "genre/movie/list"
        case .movieDetails(let id):
            return "movie/\(id)?language=en-US"
        }
    }
    
    var urlString: String {
            return baseURL + path
    }
    
    var description: String {
        return urlString
    }
}
