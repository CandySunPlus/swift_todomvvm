//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    var serviceProvider: ServiceProviderProtocol { get }
}

class ViewModel: ViewModelProtocol {
    private(set) var serviceProvider: ServiceProviderProtocol

    init(serviceProvider: ServiceProviderProtocol) {
        self.serviceProvider = serviceProvider
    }
}
