//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

class ViewModel: NSObject, ViewModelProtocol {
    private(set) var services: ViewModelServicesProtocol

    init(services: ViewModelServicesProtocol) {
        self.services = services
        super.init()
    }
}
