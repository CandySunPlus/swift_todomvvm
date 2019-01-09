//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

protocol DateServiceProtocol {
    func format(_ date: Date) -> String
}

class DateService: DateServiceProtocol {
    private let formatter = DateFormatter()

    init() {
        formatter.dateStyle = .short
        formatter.timeStyle = .short
    }

    func format(_ date: Date) -> String {
        return formatter.string(from: date)
    }
}
