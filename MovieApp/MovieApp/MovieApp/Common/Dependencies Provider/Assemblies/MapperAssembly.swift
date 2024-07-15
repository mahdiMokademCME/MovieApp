import Foundation
import Swinject

struct MapperAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(AutoMapper<([Movie], [Genre]), [MovieDTO]>.self) { resolver in
            return .init { (movies, genres) in
                var moviesDTO = [MovieDTO]()
                
                for movie in movies {
                    let movieGenres = genres.filter { movie.genreIDS.contains($0.id) }
                    let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!
                    moviesDTO.append(MovieDTO(id: movie.id, posterURL: url, title: movie.title, genres: movieGenres, productionYear: movie.releaseDate))
                }
                
                return moviesDTO
            }
        }
        
        container.register(AutoMapper<[MovieDTO], [MovieSection]>.self) { resolver in
            return .init { movies in
                let top6 = Array(movies.prefix(6))
                let forYou = Array(Array(movies.dropFirst(6)).prefix(7))
                let other = Array(movies.dropFirst(13))
                
                return [MovieSection(type: .top6, movies: top6),
                        MovieSection(type: .forYou, movies: forYou),
                        MovieSection(type: .other, movies: other)]
            }
        }
        
        container.register(AutoMapper<MovieDetailsResponse, MovieDetailsDTO>.self) { resolver in
            return .init { detailsResponse in
                let coverURL = URL(string: "https://image.tmdb.org/t/p/original\(detailsResponse.backdropPath ?? "")")!
                var newBelongsToCollection: BelongsToCollection?
                if let path = detailsResponse.belongsToCollection?.posterPath {
                    newBelongsToCollection = detailsResponse.belongsToCollection
                    newBelongsToCollection?.posterPath = "https://image.tmdb.org/t/p/original\(path)"
                }
                return .init(collection: newBelongsToCollection, genres: detailsResponse.genres, id: detailsResponse.id, originalLanguage: detailsResponse.originalLanguage, originalTitle: detailsResponse.originalTitle, overview: detailsResponse.overview, popularity: detailsResponse.popularity, backdropPath: coverURL, releaseDate: detailsResponse.releaseDate, spokenLanguages: detailsResponse.spokenLanguages, voteAverage: detailsResponse.voteAverage, voteCount: detailsResponse.voteCount)
            }
        }
    }
}
