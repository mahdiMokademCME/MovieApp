//
//  GenresRequest.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation

class GenresRequest: APIRequest<GenresList> {
    init() {
        super.init(url: .genres, methode: .get, responseObjectType: GenresList.self, params: nil, headers: nil, authentication: true, interceptor: false)
    }
}
