//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

class ViewModelServices: NSObject, ViewModelServicesProtocol {
    private(set) var todo: TodoServiceProtocol
    private(set) var date: DateServiceProtocol
    private weak var delegate: ViewModelServicesDelegate?

    init(delegate: ViewModelServicesDelegate?) {
        self.delegate = delegate
        self.todo = TodoService()
        self.date = DateService()
        super.init()
    }

    func push(viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: NavigationEvent(viewModel))
    }

    func pop(viewModel: ViewModelProtocol) {
        delegate?.services(self, navigate: .Pop)
    }
}
