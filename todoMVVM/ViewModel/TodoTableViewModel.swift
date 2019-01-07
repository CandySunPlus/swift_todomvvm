//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class TodoTableViewModel: ViewModel {
    let todos = MutableProperty<[TodoCellViewModel]>([])
    let deleteTodo: Action<(todos: [TodoCellViewModel], cell: TodoCellViewModel), NSIndexPath?, NoError>

    override init(services: ViewModelServicesProtocol) {
        super.init(services: services)

        deleteTodo = Action { (todos: [TodoCellViewModel], cell: TodoCellViewModel) -> SignalProducer<NSIndexPath?, NoError> in
            let deleteIndex = todos.firstIndex(of: cell)
            if let idx = deleteIndex {
                return services.todo.delete(cell.todo)
                        .map { _ in
                            NSIndexPath(row: idx, section: 0)
                        }
            }
            return SignalProducer(value: nil)
        }

        todos <~ deleteTodo.values.filter { (path: NSIndexPath?) in
            path != nil
        }.map { (path: NSIndexPath?) -> U in
            var tmp = todos.value
            tmp.remove(at: path?.row)
            return tmp
        }
    }

    func clearCompleted() {
        for todo in todos.value {
            if todo.completed.value {
                deleteTodo.apply((todos: todos.value, cell: todo)).start()
            }
        }
    }
}
