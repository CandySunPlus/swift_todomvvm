//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift

class ReactiveViewController<T: ViewModelProtocol>: UIViewController {
    let viewModel: T

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(viewModel: T) {
        self.init(nibName: nil, bundle: nil, viewModel: viewModel)
    }

    override required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder has not been implemented")
    }
}
