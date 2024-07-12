//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import SDWebImage

class MovieDetailsViewController: UIViewController, ViewModelBased, StoryboardBased {
    
    typealias ViewModelType = MovieDetailsViewModel
    
    var viewModel: MovieDetailsViewModel!
    
    var movieDetails: MovieDetailsDTO!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let backdropImageView = UIImageView()
    let collectionImageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let releaseDateLabel = UILabel()
    let genresLabel = UILabel()
    let spokenLanguagesLabel = UILabel()
    let popularityLabel = UILabel()
    let voteAverageLabel = UILabel()
    let voteCountLabel = UILabel()
    let collectionLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        
        viewModel.output.details.drive(onNext: { movieDetails in
            if let movieDetails {
                self.backdropImageView.sd_setImage(with: movieDetails.backdropPath)
                self.titleLabel.text = movieDetails.originalTitle ?? ""
                self.releaseDateLabel.text = movieDetails.releaseDate ?? ""
                self.genresLabel.text = (movieDetails.genres ?? []).map({ $0.name }).joined(separator: ", ")
                self.overviewLabel.text = movieDetails.overview ?? ""
                self.spokenLanguagesLabel.text = (movieDetails.spokenLanguages ?? []).map({ $0.name ?? "" }).joined(separator: ", ")
                self.voteCountLabel.text = "Vote Count: \(movieDetails.voteCount ?? 0)"
                self.voteAverageLabel.text = "Vote Average: \(movieDetails.voteAverage ?? 0)"
                self.voteAverageLabel.backgroundColor = self.colorForVotes(voteAverage: movieDetails.voteAverage ?? 0)
                self.popularityLabel.text = "Popularity: \(movieDetails.popularity ?? 0)"
                if let collectionImageURL = movieDetails.collection?.posterPath {
                    self.collectionImageView.sd_setImage(with: URL(string: collectionImageURL))
                }else{
                    self.collectionLabel.isHidden = true
                    self.collectionImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.input.details.onNext(())
    }
    
    private func colorForVotes(voteAverage: Double) -> UIColor {
        // Map popularity (0.0 to 10.0) to a color from red (low) to green (high)
        let normalized = min(max(voteAverage / 10.0, 0.0), 1.0)
        return UIColor(red: CGFloat(1.0 - normalized), green: CGFloat(normalized), blue: 0.0, alpha: 1.0)
    }
}
