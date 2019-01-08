//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

class TodoTableViewModel: ViewModel {
    let todos = MutableProperty<[TodoCellViewModel]>([])
    let presentCreateTodo: Action<(), CreateTodoViewModel, NoError>
    let deleteTodo: Action<(todos: [TodoCellViewModel], cell: TodoCellViewModel), IndexPath?, NoError>

    override init(services: ViewModelServicesProtocol) {

        self.presentCreateTodo = Action { () -> SignalProducer<CreateTodoViewModel, NoError> in
            return SignalProducer(value: CreateTodoViewModel(services: services))
        }

        deleteTodo = Action { (todos: [TodoCellViewModel], cell: TodoCellViewModel) -> SignalProducer<IndexPath?, NoError> in
            let deleteIndex = todos.firstIndex(of: cell)
            if let idx = deleteIndex {
                return services.todo.delete(cell.todo)
                        .map { _ in
                            return IndexPath(row: idx, section: 0)
                        }
            }
            return SignalProducer(value: nil)
        }
        super.init(services: services)

        let createdTodoSignal = presentCreateTodo.values.flatMap(.latest) { (viewModel: CreateTodoViewModel) -> Signal<Todo, NoError> in
            return viewModel.create.values
        }

        presentCreateTodo.values.observeValues(services.push)
        presentCreateTodo.values.flatMap(.latest) { (viewModel: CreateTodoViewModel) in
            return viewModel.cancel.values.map { _ in
                return viewModel
            }
        }.observeValues(services.pop)

        presentCreateTodo.values.flatMap(.latest) { (viewModel: CreateTodoViewModel) in
            return viewModel.create.values.map { _ in
                return viewModel
            }
        }.observeValues(services.pop)

        todos <~ createdTodoSignal.map { [unowned self] todo -> [TodoCellViewModel] in
            let new = TodoCellViewModel(services: services, todo: todo)
            var tmp = self.todos.value
            tmp.insert(new, at: 0)
            return tmp
        }

        todos <~ deleteTodo.values
                .skipNil()
                .map { [unowned self] (path: IndexPath) -> [TodoCellViewModel] in
                    var tmp = self.todos.value
                    tmp.remove(at: path.row)
                    return tmp
                }
    }

    @objc func clearCompleted() {
        for todo in todos.value {
            if todo.completed.value {
                deleteTodo.apply((todos: todos.value, cell: todo)).start()
            }
        }
    }
}
