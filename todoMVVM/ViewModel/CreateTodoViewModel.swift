//
// Created by Fengming Sun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class CreateTodoViewModel: ViewModel {
    let note = MutableProperty<String>("")
    let dueDateText = MutableProperty<String>("")
    let dueDate: MutableProperty<Date>
    let cancel: Action<(), (), NoError>
    let create: Action<(note: String, due: Date), Todo, NoError>

    override init(serviceProvider: ServiceProviderProtocol) {
        self.dueDate = MutableProperty(Date().addingTimeInterval(60 * 60))
        let createEnabled = MutableProperty(false)
        self.create = Action(enabledIf: createEnabled) { (note: String, due: Date) -> SignalProducer<Todo, NoError> in
            return serviceProvider.todo.create(note, dueDate: due)
        }
        self.cancel = Action { () -> SignalProducer<(), NoError> in
            return SignalProducer(value: ())
        }
        super.init(serviceProvider: serviceProvider)

        createEnabled <~ note.producer
                .map { note -> Bool in
            return note.count > 0
        }

        dueDateText <~ dueDate.producer
                .map { date -> String in
            return "Due at: \(serviceProvider.date.format(date))"
        }
    }
}
