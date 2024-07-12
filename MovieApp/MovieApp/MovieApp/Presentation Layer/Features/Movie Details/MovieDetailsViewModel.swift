//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieDetailsViewModelInput {
    let details: AnyObserver<Void>
}

struct MovieDetailsViewModelOutput {
    let details: Driver<MovieDetailsDTO?>
}

class MovieDetailsViewModel: ViewModel {
    
    typealias Input = MovieDetailsViewModelInput
    
    typealias Output = MovieDetailsViewModelOutput
    
    var input: MovieDetailsViewModelInput
    
    var output: MovieDetailsViewModelOutput
    
    let disposeBag = DisposeBag()
    
    init(moviesRepo: MoviesRepository, mapper: AutoMapper<MovieDetailsResponse, MovieDetailsDTO>, movieID: Int, coordinator: MainCoordinator){
        
        let detailsPublishSubject = PublishSubject<Void>()
        
        input = .init(details: detailsPublishSubject.asObserver())
        
        let detailsOutputPublishSubject = PublishSubject<MovieDetailsDTO?>()
        
        output = .init(details: detailsOutputPublishSubject.asDriver(onErrorJustReturn: nil))
        
        detailsPublishSubject
            .mapTo((moviesRepo, movieID, mapper))
            .flatMapLatest(detailsAPI)
            .bind(to: detailsOutputPublishSubject)
            .disposed(by: disposeBag)
    }
    
    private func detailsAPI(moviesRepo: MoviesRepository, id: Int, mapper: AutoMapper<MovieDetailsResponse, MovieDetailsDTO>)-> Observable<MovieDetailsDTO> {
        return .create { observer in
            Task {
                do {
                    let response = try await moviesRepo.getDetails(id: id)
                    let detailsDTO = mapper.map(from: response)
                    observer.onNext(detailsDTO)
                } catch {
                    //Handle error
                }
            }
            return Disposables.create()
        }
    }
    
}
