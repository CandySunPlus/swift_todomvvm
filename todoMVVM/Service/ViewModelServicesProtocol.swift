//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol ViewModelServicesDelegate: class {
    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent)
}

protocol ViewModelServicesProtocol {
    var todo: TodoServiceProtocol { get }
    var date: DateServiceProtocol { get }
    func push(viewModel: ViewModelProtocol)
    func pop(viewModel: ViewModelProtocol)
}
