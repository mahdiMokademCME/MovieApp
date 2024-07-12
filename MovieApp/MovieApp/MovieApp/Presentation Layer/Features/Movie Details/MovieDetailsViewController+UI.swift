//
//  MovieDetailsViewController+UI.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 12/07/2024.
//

import Foundation
import UIKit

extension MovieDetailsViewController {
    
    func buildUI() {
        setupElementsConstraints()
    }
    
    private func setupElementsConstraints() {
        
        // Scroll view setup
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Backdrop ImageView setup
        contentView.addSubview(backdropImageView)
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title Label setup
        contentView.addSubview(titleLabel)
        titleLabel.font = Fonts.movieBigTitle
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Overview Label setup
        contentView.addSubview(overviewLabel)
        overviewLabel.font = Fonts.overviewLabel
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Release Date Label setup
        contentView.addSubview(releaseDateLabel)
        releaseDateLabel.font = Fonts.dateLabel
        releaseDateLabel.textColor = Colors.hintsColor
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Genres Label setup
        contentView.addSubview(genresLabel)
        genresLabel.font = Fonts.genres
        genresLabel.textColor = Colors.hintsColor
        genresLabel.numberOfLines = 0
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Spoken Languages Label setup
        contentView.addSubview(spokenLanguagesLabel)
        spokenLanguagesLabel.font = Fonts.spokenLanguage
        spokenLanguagesLabel.textColor = Colors.hintsColor
        spokenLanguagesLabel.numberOfLines = 0
        spokenLanguagesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Popularity Label setup
        contentView.addSubview(popularityLabel)
        popularityLabel.font = Fonts.hintsLabel
        popularityLabel.textColor = Colors.hintsColor
        popularityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Vote Average Label setup
        contentView.addSubview(voteAverageLabel)
        voteAverageLabel.font = Fonts.hintsLabel
        voteAverageLabel.textColor = .white
        voteAverageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Vote Count Label setup
        contentView.addSubview(voteCountLabel)
        voteCountLabel.font = Fonts.hintsLabel
        voteCountLabel.textColor = Colors.hintsColor
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Collection Label setup
        contentView.addSubview(collectionLabel)
        collectionLabel.font = Fonts.hintsLabel
        collectionLabel.textColor = Colors.movieTitleColor
        collectionLabel.text = "Collection Image:"
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Collection ImageView setup
        contentView.addSubview(collectionImageView)
        collectionImageView.contentMode = .scaleAspectFill
        collectionImageView.clipsToBounds = true
        collectionImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            releaseDateLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            genresLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            genresLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genresLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            spokenLanguagesLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 8),
            spokenLanguagesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            spokenLanguagesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            popularityLabel.topAnchor.constraint(equalTo: spokenLanguagesLabel.bottomAnchor, constant: 8),
            popularityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            popularityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            voteAverageLabel.topAnchor.constraint(equalTo: popularityLabel.bottomAnchor, constant: 8),
            voteAverageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            voteAverageLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 8),
            
            voteCountLabel.topAnchor.constraint(equalTo: voteAverageLabel.bottomAnchor, constant: 8),
            voteCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            voteCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionLabel.topAnchor.constraint(equalTo: voteCountLabel.bottomAnchor, constant: 24),
            collectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            collectionImageView.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 8),
            collectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionImageView.widthAnchor.constraint(equalToConstant: 150),
            collectionImageView.heightAnchor.constraint(equalToConstant: 300),
            collectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
