//
//  Style1MoviesCollectionViewCell.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import UIKit
import SDWebImage

class Style1MoviesCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Style1MoviesCollectionViewCell"
    
    var posterImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.movieTitleColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Fonts.movieSmallTitle
        return label
    }()
    
    var titleView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(posterImage)
        contentView.addSubview(titleView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            titleView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            titleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(movie: MovieDTO) {
        self.posterImage.sd_setImage(with: movie.posterURL)
        
        titleLabel.text = movie.title
    }
}
