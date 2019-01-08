//
// Created by niksun on 2019-01-07.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class TodoTableViewController: ReactiveViewController<TodoTableViewModel>, UITableViewDataSource, UITableViewDelegate {
    let todoTableView = UITableView(frame: .zero, style: .plain)
    var clearTodosButton: UIBarButtonItem!
    var createTodoButton: UIBarButtonItem!

    private var didSetupConstraints = false

    init(viewModel: TodoTableViewModel) {
        super.init(nibName: nil, bundle: nil, viewModel: viewModel)
        createTodoButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.createTodoButtonPressed))
        clearTodosButton = UIBarButtonItem(title: "Clear", style: .plain, target: viewModel, action: #selector(viewModel.clearCompleted))
        todoTableView.estimatedRowHeight = 80
        todoTableView.rowHeight = UITableView.automaticDimension
        todoTableView.dataSource = self
        todoTableView.delegate = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(todoTableView)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !didSetupConstraints {
            todoTableView.snp.makeConstraints { maker in
                maker.edges.equalTo(self.view)
            }
            didSetupConstraints = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Todos"
        navigationItem.leftBarButtonItem = clearTodosButton
        navigationItem.rightBarButtonItem = createTodoButton

        viewModel.presentCreateTodo.values
                .flatMap(.latest) { (viewModel: CreateTodoViewModel) in
                    return viewModel.create.values
                }.map { _ in
                    return IndexPath(row: 0, section: 0)
                }.observe(on: UIScheduler())
                .observeValues { [weak self] (indexPath: IndexPath) -> Void in
                    self?.todoTableView.insertRows(at: [indexPath], with: .right)
                }

        viewModel.deleteTodo.values
                .skipNil()
                .observe(on: UIScheduler())
                .observeValues { [weak self] (indexPath: IndexPath) in
                    self?.todoTableView.deleteRows(at: [indexPath], with: .left)
                }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = viewModel.todos.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.reuseIdentifier()) as! ReactiveTableViewCell<TodoCellViewModel>
        cell.bindViewModel(vm)
        return cell;
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let vm = viewModel.todos.value[indexPath.row]
            viewModel.deleteTodo.apply((todos: viewModel.todos.value, cell: vm))
                    .start(on: QueueScheduler(qos: .background, name: "TodoCell.Remove"))
                    .start()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModel.todos.value[indexPath.row]
        vm.completed.value = !vm.completed.value
    }

    @objc func createTodoButtonPressed() {
        viewModel.presentCreateTodo.apply().start()
    }
}

