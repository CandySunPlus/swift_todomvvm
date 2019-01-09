//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol ServiceProviderProtocol {
    var todo: TodoServiceProtocol { get }
    var date: DateServiceProtocol { get }
    var navigation: NavigationServiceProtocol { get }
}

class ServiceProvider: ServiceProviderProtocol {
    private(set) var navigation: NavigationServiceProtocol
    private(set) var todo: TodoServiceProtocol
    private(set) var date: DateServiceProtocol

    init(withNavigationDelegate navigationDelegate: NavigationServiceDelegate?) {
        self.todo = TodoService()
        self.date = DateService()
        self.navigation = NavigationService(delegate: navigationDelegate)
    }
}
