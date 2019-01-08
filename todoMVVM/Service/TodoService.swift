//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol TodoServiceProtocol {
    func update(_ todo: Todo) -> SignalProducer<Todo, NoError>
    func delete(_ todo: Todo) -> SignalProducer<Bool, NoError>
    func create(_ note: String, dueDate: Date) -> SignalProducer<Todo, NoError>
}

class TodoService: NSObject, TodoServiceProtocol {
    func update(_ todo: Todo) -> SignalProducer<Todo, NoError> {
        return SignalProducer(value: todo)
    }

    func delete(_ todo: Todo) -> SignalProducer<Bool, NoError> {
        return SignalProducer(value: true)
    }

    func create(_ note: String, dueDate: Date) -> SignalProducer<Todo, NoError> {
        let id = randomInt(0, max: 100000)
        let todo = Todo(id: id, note: note, dueDate: dueDate, completed: false)
        return SignalProducer(value: todo)
    }
}
