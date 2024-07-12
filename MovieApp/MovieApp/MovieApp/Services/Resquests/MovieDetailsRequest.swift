//
//  MovieDetailsRequest.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation

class MovieDetailsRequest: APIRequest<MovieDetailsResponse> {
    init(id: Int) {
        super.init(url: .movieDetails(id: id), methode: .get, responseObjectType: MovieDetailsResponse.self, params: nil, headers: nil, authentication: true,  interceptor: false)
    }
}
