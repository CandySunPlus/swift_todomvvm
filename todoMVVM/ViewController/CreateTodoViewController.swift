//
// Created by Fengming Sun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

class CreateTodoViewController: ReactiveViewController<CreateTodoViewModel> {
    let noteLabel = UILabel()
    let noteTextField = UITextField()
    let dueDateLabel = UILabel()
    let dueDatePicker = UIDatePicker()
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    private var didSetupConstraints = false

    init(viewModel: CreateTodoViewModel) {
        super.init(nibName: nil, bundle: nil, viewModel: viewModel)

        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))

        noteLabel.text = "What do you have to do?"
        noteLabel.font = .boldSystemFont(ofSize: 16)

        noteTextField.backgroundColor = .white
        noteTextField.borderStyle = .roundedRect
        noteTextField.placeholder = "e.g. get more sleep"

        dueDateLabel.font = .boldSystemFont(ofSize: 16)
        dueDatePicker.date = viewModel.dueDate.value
        dueDatePicker.minimumDate = Date()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.addSubview(noteLabel)
        view.addSubview(noteTextField)
        view.addSubview(dueDateLabel)
        view.addSubview(dueDatePicker)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !didSetupConstraints {
            noteLabel.snp.makeConstraints { [unowned self] maker in
                maker.top.left.equalTo(self.view).offset(8)
            }
            noteTextField.snp.makeConstraints { [unowned self] maker in
                maker.left.equalTo(self.noteLabel)
                maker.right.equalTo(self.view).offset(-8)
                maker.top.equalTo(self.noteLabel.snp.bottom).offset(8)
            }

            dueDateLabel.snp.makeConstraints { [unowned self] maker in
                maker.left.equalTo(self.noteLabel)
                maker.top.equalTo(self.noteTextField.snp.bottom).offset(16)
            }
            dueDatePicker.snp.makeConstraints { [unowned self] maker in
                maker.width.equalTo(self.view)
                maker.top.equalTo(self.dueDateLabel.snp.bottom).offset(4)
            }

            didSetupConstraints = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)

        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton

        title = "New Todo"
        view.backgroundColor = .white

        saveButton.reactive.isEnabled <~ viewModel.create.isEnabled
        viewModel.note <~ noteTextField.reactive.continuousTextValues.map {
            $0!
        }
        viewModel.dueDate <~ dueDatePicker.reactive
                .controlEvents(UIControl.Event.valueChanged)
                .map { picker -> Date in
                    return picker.date
                }
        dueDateLabel.reactive.text <~ viewModel.dueDateText
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteTextField.becomeFirstResponder()
    }

    @objc func save() {
        viewModel.create
                .apply((note: viewModel.note.value, due: viewModel.dueDate.value))
                .start()
    }

    @objc func cancel() {
        viewModel.cancel.apply().start()
    }
}
