//
//  MainCoordinator.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let popularMoviesVC =  DependencyProvider.shared.resolve(PopularMoviesViewController.self, argument: self)!
        self.navigationController.pushViewController(popularMoviesVC, animated: true)
    }
    
    func movieDetails(id: Int) {
        let vc = DependencyProvider.shared.resolve(MovieDetailsViewController.self, arguments: self, id)!
        self.navigationController.pushViewController(vc, animated: true)
    }
}
