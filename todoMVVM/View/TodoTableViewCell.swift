//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift
import Result

class TodoTableViewCell: ReactiveTableViewCell<TodoCellViewModel> {
    let noteLabel = UILabel()
    let dueDateLabel = UILabel()
    private var didSetupConstraints = false

    override class func reuseIdentifier() -> String {
        return "cn.sfmblog.TodoTableCell"
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(noteLabel)
        dueDateLabel.font = .systemFont(ofSize: 12.0)
        contentView.addSubview(dueDateLabel)

        noteLabel.reactive.text <~ vm_signal
                .map { (model: TodoCellViewModel) -> String in
                    return model.note
                }
                .skipRepeats()
                .observe(on: UIScheduler())

        vm_signal
                .flatMap(.latest) { (model: TodoCellViewModel) -> SignalProducer<Bool, NoError> in
                    return model.completed.producer
                }.skipRepeats()
                .observe(on: UIScheduler())
                .observeValues { [weak self] (completed: Bool) -> Void in
                    self?.accessoryType = completed ? .checkmark : .none
                }

        dueDateLabel.reactive.text <~ vm_signal
                .map { (model: TodoCellViewModel) -> String in
                    return model.dueDateText
                }.skipRepeats()
                .observe(on: UIScheduler())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder has not been implemented")
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !didSetupConstraints {
            noteLabel.snp.makeConstraints { maker in
                maker.left.equalTo(self.contentView.snp.left).offset(8)
                maker.top.equalTo(self.contentView.snp.top).offset(8)
                maker.right.equalTo(self.contentView.snp.right).offset(-16)
            }

            dueDateLabel.snp.makeConstraints { maker in
                maker.left.right.equalTo(self.noteLabel)
                maker.top.equalTo(self.noteLabel.snp.bottom).offset(4)
                maker.bottom.equalTo(self.contentView).offset(-8)
            }

            didSetupConstraints = true
        }
    }
}
