//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation

class Todo: Equatable {
    let id: Int
    let note: String
    let createAt: Date
    let dueDate: Date
    let completed: Bool

    init(id: Int, note: String, createAt: Date = Date(), dueDate: Date, completed: Bool) {
        self.id = id
        self.note = note
        self.createAt = createAt
        self.dueDate = dueDate
        self.completed = completed
    }

    func markAs(completed: Bool) -> Todo {
        return Todo(id: id, note: note, createAt: createAt, dueDate: dueDate, completed: completed)
    }

    static func ==(lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id &&
                lhs.note == rhs.note &&
                lhs.createAt == rhs.createAt &&
                lhs.dueDate == rhs.dueDate &&
                lhs.completed == rhs.completed
    }
}
