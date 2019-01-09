//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift

class TodoCellViewModel: ViewModel {
    let note: String
    let dueDateText: String
    let completed: MutableProperty<Bool>

    private var _todo: MutableProperty<Todo>
    var todo: Todo {
        return _todo.value
    }

    init(serviceProvider: ServiceProviderProtocol, todo: Todo) {
        _todo = MutableProperty(todo)
        note = todo.note
        dueDateText = "Due: \(serviceProvider.date.format(todo.dueDate))"
        completed = MutableProperty(todo.completed)
        super.init(serviceProvider: serviceProvider)

        _todo <~ completed.producer
                .skip(first: 1)
                .map(_todo.value.markAs)
                .flatMap(.latest, serviceProvider.todo.update)
    }
}
