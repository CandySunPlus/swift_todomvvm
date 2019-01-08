//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import UIKit

enum NavigationEvent {
    enum PushStyle {
        case Push, Modal
    }

    case Push(UIViewController, PushStyle)
    case Pop

    init(_ viewModel: ViewModelProtocol) {
        if let vm = viewModel as? TodoTableViewModel {
            self = .Push(TodoTableViewController(viewModel: vm), .Push)
        } else {
            self = .Push(UIViewController() , .Push)
        }
    }
}
