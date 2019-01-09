//
// Created by Fengming Sun on 2019-01-09.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol NavigationServiceDelegate {
    func navigate(withNavigateEvent navigateEvent: NavigationEvent)
}

protocol NavigationServiceProtocol {
    var delegate: NavigationServiceDelegate? { get }
    func push(withViewModel viewModel: ViewModelProtocol)
    func pop(withViewModel viewModel: ViewModelProtocol)
}

class NavigationService: NavigationServiceProtocol {
    private(set) var delegate: NavigationServiceDelegate?

    func push(withViewModel viewModel: ViewModelProtocol) {
        self.delegate?.navigate(withNavigateEvent: NavigationEvent(viewModel))
    }

    func pop(withViewModel viewModel: ViewModelProtocol) {
        self.delegate?.navigate(withNavigateEvent: .Pop)
    }

    init(delegate: NavigationServiceDelegate?) {
        self.delegate = delegate
    }
}
