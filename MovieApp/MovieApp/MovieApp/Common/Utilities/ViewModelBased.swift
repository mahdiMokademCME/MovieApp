//
//  ViewModelBased.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation

protocol ViewModelBased: AnyObject {
    associatedtype ViewModelType: ViewModel
    var viewModel: ViewModelType! { get set }
}

protocol ViewModelBindable: AnyObject {
    func bindViewModel()
}

extension ViewModelBindable {
    func bindViewModel() {}
}
