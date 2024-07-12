//
//  PopularMoviesViewController.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class PopularMoviesViewController: UIViewController, ViewModelBased, StoryboardBased, UISearchBarDelegate, UICollectionViewDelegate {
    
    var viewModel: PopularMoviesViewModel!
    
    typealias ViewModelType = PopularMoviesViewModel
    
    let disposeBag = DisposeBag()
    
    let searchBar = UISearchBar()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    var collectionView : UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<MovieSectionType, MovieDTO>!
    
    var sections: [MovieSection] = []
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        buildUI()
        
        activityIndicator.startAnimating()
        
        viewModel
            .output
            .movies
            .map {$0}
            .asObservable()
            .flatMapLatest(self.handleMoviesSectionsReceived)
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.input.popularMovies.onNext(())
        
        collectionView.delegate = self
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.input.search.onNext(searchText)
    }
    
    private func handleMoviesSectionsReceived(sections: [MovieSection])->Observable<Void> {
        return .create { observer in
            self.activityIndicator.stopAnimating()
            self.sections = sections
            var snapshot = NSDiffableDataSourceSnapshot<MovieSectionType, MovieDTO>()
            snapshot.appendSections(sections.map {$0.type})
            for type in sections.map({ $0.type }) {
                snapshot.appendItems(sections.filter{ $0.type == type}.first?.movies ?? [], toSection: type)
            }
            self.dataSource.apply(snapshot, animatingDifferences: true)
            observer.onNext(())
            return Disposables.create()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieID = sections[indexPath.section].movies[indexPath.row].id
        viewModel.input.moviePressed.onNext(movieID)
    }
}
