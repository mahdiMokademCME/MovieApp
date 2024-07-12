//
//  PopularMoviesViewModel.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt

struct PopularMoviesViewModelInput {
    let popularMovies: AnyObserver<Void>
    let loadMore: AnyObserver<Void>
    let search: AnyObserver<String?>
    let moviePressed: AnyObserver<Int>
}

struct PopularMoviesViewModelOutput {
    let movies: Driver<[MovieSection]>
}

class PopularMoviesViewModel: ViewModel {
    
    typealias Input = PopularMoviesViewModelInput
    typealias Output = PopularMoviesViewModelOutput
    
    var input: PopularMoviesViewModelInput
    
    var output: PopularMoviesViewModelOutput
    
    let disposeBag = DisposeBag()
    
    var movies = [MovieDTO]()
    var genres = [Genre]()
    var currentPageFetched = 0
    
    init(moviesRepo: MoviesRepository, moviesMapper: AutoMapper<([Movie], [Genre]), [MovieDTO]>, movieSectionsMapper: AutoMapper<[MovieDTO], [MovieSection]>, coordinator: MainCoordinator) {
        
        let moviesPublishSubject = PublishSubject<Void>()
        let loadMorePublishSubject = PublishSubject<Void>()
        let searchPublishSubject = PublishSubject<String?>()
        let moviePublishSubject = PublishSubject<Int>()
        
        input = .init(popularMovies: moviesPublishSubject.asObserver(), loadMore: loadMorePublishSubject.asObserver(), search: searchPublishSubject.asObserver(), moviePressed: moviePublishSubject.asObserver())
        
        let moviesOutputPublishSubject = PublishSubject<[MovieSection]>()
        output = .init(movies: moviesOutputPublishSubject.asDriver(onErrorJustReturn: []))
        
        moviesPublishSubject
            .mapTo(moviesRepo)
            .flatMap(genresAPI)
            .map { genres in  return (moviesRepo, genres, moviesMapper) }
            .flatMapLatest(moviesAPI)
            .map { ($0, movieSectionsMapper) }
            .flatMapLatest(mapToSections)
            .bind(to: moviesOutputPublishSubject)
            .disposed(by: disposeBag)
        
        loadMorePublishSubject
            .mapTo((moviesRepo, genres, moviesMapper))
            .flatMapLatest(moviesAPI)
            .map { ($0, movieSectionsMapper) }
            .flatMapLatest(mapToSections)
            .bind(to: moviesOutputPublishSubject)
            .disposed(by: disposeBag)
        
        searchPublishSubject
            .flatMapLatest { text -> Observable<[MovieSection]> in
                if let text, !text.isEmpty {
                    //in case search text is not nil or empty, search
                    return self.search(text: text)
                }else{
                    //in case search text is empty or nil, return original movies
                    return self.mapToSections(movies: self.movies, mapper: movieSectionsMapper)
                }
            }
            .bind(to: moviesOutputPublishSubject)
            .disposed(by: disposeBag)
        
        moviePublishSubject
            .subscribe(onNext: { id in
                coordinator.movieDetails(id: id)
            }).disposed(by: disposeBag)
    }
    
    private func search(text: String)-> Observable<[MovieSection]> {
        return .create { observer in
            
            let result = self.movies.filter {(
                 $0.title.contains(text) ||
                 $0.productionYear.contains(text) ||
                 $0.genres.map {$0.name}.joined().contains(text)
                )}
            observer.onNext([MovieSection(type: .other, movies: result)])
            return Disposables.create()
        }
    }
    
    private func moviesAPI(moviesRepo: MoviesRepository, genres: [Genre], moviesMapper: AutoMapper<([Movie], [Genre]), [MovieDTO]>)-> Observable<[MovieDTO]> {
        return .create { observer in
            Task { [weak self] in
                do {
                    let nextPage = (self?.currentPageFetched ?? 0) + 1
                    let moviesList = try await moviesRepo.popularMovies(page: nextPage)
                    self?.currentPageFetched = moviesList.page
                    let moviesDTO = moviesMapper.map(from: (moviesList.movies, genres))
                    self?.movies.append(contentsOf: moviesDTO)
                    observer.onNext(self?.movies ?? [])
                } catch {
                    //Handle the Error
                }
            }
            return Disposables.create()
        }
    }
    
    private func mapToSections(movies: [MovieDTO], mapper: AutoMapper<[MovieDTO], [MovieSection]>) -> Observable<[MovieSection]> {
        return .create { observer in
            let sections = mapper.map(from: movies)
            observer.onNext(sections)
            return Disposables.create()
        }
    }
    
    private func genresAPI(moviesRepo: MoviesRepository)-> Observable<[Genre]> {
        return .create { observer in
            Task { [weak self] in
                do {
                    let genresList = try await moviesRepo.genres()
                    self?.genres = genresList.genres
                    observer.onNext(genresList.genres)
                }catch {
                    //Handle the Error
                }
            }
            
            return Disposables.create()
        }
    }
}
