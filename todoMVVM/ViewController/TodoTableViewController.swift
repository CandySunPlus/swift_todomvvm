//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import UIKit

class TodoTableViewController: ReactiveViewController<TodoTableViewModel>, UITableViewDataSource, UITableViewDelegate {
    let todoTableView = UITableView(frame: .zero, style: .plain)
    var clearTodosButton: UIBarButtonItem!

    private var didSetupConstraints = false

    init(viewModel: TodoTableViewModel) {
        super.init(nibName: nil, bundle: nil, viewModel: viewModel)
        clearTodosButton = UIBarButtonItem(title: "Clear", style: .plain, target: viewModel, action: "clearCompleted")
        
    }

}
