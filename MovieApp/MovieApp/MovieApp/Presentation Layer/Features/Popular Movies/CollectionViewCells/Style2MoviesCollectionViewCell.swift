//
//  Style2MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation
import UIKit
import SDWebImage

class Style2MoviesCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "Style2MoviesCollectionViewCell"
    
    // Define the UI elements
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.movieMediumTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    let publishDateLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.dateLabel
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.genres
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add subviews to the content view
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(publishDateLabel)
        contentView.addSubview(tagsLabel)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            // Image view constraints
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            // Title label constraints
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            // Publish date label constraints
            publishDateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            publishDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            publishDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            // Tags label constraints
            tagsLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tagsLabel.topAnchor.constraint(equalTo: publishDateLabel.bottomAnchor, constant: 4),
            tagsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(movie: MovieDTO) {
        self.imageView.sd_setImage(with: movie.posterURL)
        self.titleLabel.text = movie.title
        self.publishDateLabel.text = movie.productionYear
        self.tagsLabel.text = movie.genres.map({ $0.name }).joined(separator: ",")
    }
}
