//
//  PopularMoviesViewController+UI.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import UIKit

extension PopularMoviesViewController {
    
    func buildUI() {
        setupSearchBar()
        setUpCollectionView()
        setupActivityIndicator()
        
        buildDataSource()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search by: Title, Date or Genres"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(Style1MoviesCollectionViewCell.self, forCellWithReuseIdentifier: Style1MoviesCollectionViewCell.reuseIdentifier)
        collectionView.register(Style2MoviesCollectionViewCell.self, forCellWithReuseIdentifier: Style2MoviesCollectionViewCell.reuseIdentifier)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout()-> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let sectionType = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            if sectionType == .top6 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                                     subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [self.createHeaderForSection()]
                section.contentInsets = self.sectionContentInsets(section: section)
                
                return section
            }else if sectionType == .forYou {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.boundarySupplementaryItems = [self.createHeaderForSection()]
                section.contentInsets = self.sectionContentInsets(section: section)
                
                return section
            }else{
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                //Add header for section
                section.boundarySupplementaryItems = [self.createHeaderForSection()]
                
                section.contentInsets = self.sectionContentInsets(section: section)
                
                //Implement the following to add the loadMore functionality, use timestamp so load more is not called too many times.
                var lastTimeLoadedTimeStamp = NSDate().timeIntervalSince1970
                
                section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
                    let currentTimeStamp: TimeInterval = NSDate().timeIntervalSince1970
                    let delta = currentTimeStamp - lastTimeLoadedTimeStamp
                    let indexPath = visibleItems.last!.indexPath
                    let isNotSearching = (self?.searchBar.text == nil || (self?.searchBar.text ?? "").isEmpty)
                    if isNotSearching && delta > 2  && (indexPath.row + 1) == self?.sections.filter({ movieSection in
                        return movieSection.type == .other
                    }).first?.movies.count ?? 0 {
                        lastTimeLoadedTimeStamp = NSDate().timeIntervalSince1970
                        self?.viewModel.input.loadMore.onNext(())
                    }
                }
                return section
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    
    private func createHeaderForSection()-> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
       return header
    }
    
    private func sectionContentInsets(section: NSCollectionLayoutSection)-> NSDirectionalEdgeInsets {
        var contentInsets = section.contentInsets
        contentInsets.top = 0
        contentInsets.bottom = 30
        return contentInsets
    }
    
    private func buildDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MovieSectionType, MovieDTO>(collectionView: self.collectionView , cellProvider: { (collectionView, indexPath, movie)-> UICollectionViewCell? in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if section == .top6 || section == .forYou {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Style1MoviesCollectionViewCell.reuseIdentifier, for: indexPath) as! Style1MoviesCollectionViewCell
                if section == .forYou {
                    cell.titleView.isHidden = true
                    cell.titleLabel.isHidden = true
                } else {
                    cell.titleView.isHidden = false
                    cell.titleLabel.isHidden = false
                }
                cell.setUp(movie: movie)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Style2MoviesCollectionViewCell.reuseIdentifier, for: indexPath) as! Style2MoviesCollectionViewCell
                cell.setUp(movie: movie)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if section == .top6 {
                header.titleLabel.text = "TOP 6 MOVIES"
            }else if section == .forYou {
                header.titleLabel.text = "YOUR NEXT WATCH"
            }else {
                header.titleLabel.text = "OTHER MOVIES WE HAVE"
            }
            
            return header
        }
    }
}

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeader"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = Fonts.popularMoviesHeader
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
