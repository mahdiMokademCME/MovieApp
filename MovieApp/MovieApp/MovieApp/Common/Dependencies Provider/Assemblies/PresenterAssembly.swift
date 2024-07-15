import Foundation
import Swinject

class PresenterAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(PopularMoviesViewModel.self) { (resolver, coordinator: MainCoordinator) in
            let moviesRepo = resolver.resolve(MoviesRepository.self)!
            let moviesMapper = resolver.resolve(AutoMapper<([Movie], [Genre]), [MovieDTO]>.self)!
            let movieSectionsMapper = resolver.resolve(AutoMapper<[MovieDTO], [MovieSection]>.self)!
            return .init(moviesRepo: moviesRepo, moviesMapper: moviesMapper, movieSectionsMapper: movieSectionsMapper, coordinator: coordinator)
        }
        
        container.register(PopularMoviesViewController.self) { (resolver, coordinator: MainCoordinator) in
            let viewModel =  resolver.resolve(PopularMoviesViewModel.self, argument: coordinator)!
            return PopularMoviesViewController.instantiate(withViewModel: viewModel)
        }
        
        container.register(MovieDetailsViewModel.self) { (resolver, coordinator: MainCoordinator, id: Int) in
            let moviesRepo = resolver.resolve(MoviesRepository.self)!
            let moviesMapper = resolver.resolve(AutoMapper<MovieDetailsResponse, MovieDetailsDTO>.self)!
            return .init(moviesRepo: moviesRepo, mapper: moviesMapper, movieID: id, coordinator: coordinator)
        }
        
        container.register(MovieDetailsViewController.self) { (resolver, coordinator: MainCoordinator, id: Int) in
            let viewModel =  resolver.resolve(MovieDetailsViewModel.self, arguments: coordinator, id)!
            return MovieDetailsViewController.instantiate(withViewModel: viewModel)
        }
        
    }
}
