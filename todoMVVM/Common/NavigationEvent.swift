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
        return .Push(UIViewController() , .Push)
    }
}
