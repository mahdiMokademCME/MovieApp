//
//  Coordinator.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
    func dismiss(animated: Bool)
}

extension Coordinator {
    func dismiss(animated: Bool){
        self.navigationController.popViewController(animated: animated)
    }
}
