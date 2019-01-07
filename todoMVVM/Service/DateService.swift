//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol DateServiceProtocol {
    func format(_ date: NSDate) -> String
}

class DateService: NSObject, DateServiceProtocol {
    private let formatter = DateFormatter()

    init() {
        formatter.dateStyle = .short
        formatter.timeStyle = .short
    }

    func format(_ date: NSDate) -> String {
        return formatter.string(from: date)
    }
}
