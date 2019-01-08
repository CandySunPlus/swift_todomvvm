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

    init(services: ViewModelServicesProtocol, todo: Todo) {
        _todo = MutableProperty(todo)
        note = todo.note
        dueDateText = "Due: \(services.date.format(todo.dueDate))"
        completed = MutableProperty(todo.completed)
        super.init(services: services)

        _todo <~ completed.producer
                .skip(first: 1)
                .map(_todo.value.markAs)
                .flatMap(.latest, services.todo.update)
    }
}
