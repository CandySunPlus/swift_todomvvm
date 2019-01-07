//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ReactiveCocoa
import ReactiveSwift

class TodoTableViewCell: ReactiveTableViewCell<TodoCellViewModel> {
    let noteLabel = UILabel()
    let dueDateLabel = UILabel()
    private var didSetupConstraints = false

    override var reuseIdentifier: String? {
        return "cn.sfmblog.TodoTableCell"
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(noteLabel)
        dueDateLabel.font = .systemFont(ofSize: 12.0)
        contentView.addSubview(dueDateLabel)

        noteLabel.reactive.text <~ vm_signal
                .map { (model: TodoCellViewModel) -> U in
                    model.note
                }
                .skipRepeats()
                .observe(on: UIScheduler())

        vm_signal
                .flatMap(.latest) { (model: TodoCellViewModel) -> SignalProducer<U, F> in
                    model.completed.producer
                }.skipRepeats()
                .observe(on: UIScheduler())
                .observe { (event: Signal.Event) in
                    accessoryType = event ? .checkmark : .none
                }

        dueDateLabel.reactive.text <~ vm_signal
                .map { (model: TodoCellViewModel) -> U in
                    model.dueDateText
                }.skipRepeats()
                .observe(on: UIScheduler())
    }

    override required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder has not been implemented")
    }

    override func updateConstraints() {
        super.updateConstraints()
        if !didSetupConstraints {
            noteLabel.snp_makeConstraints { maker in
                maker.left.equalTo(self.contentView.snp_left).offset(8)
                maker.top.equalTo(self.contentView.snp_top).offset(8)
                maker.right.equalTo(self.contentView.snp_right).offset(-16)
            }

            dueDateLabel.snp_makeConstraints { maker in
                maker.left.right.equalTo(self.noteLabel)
                maker.top.equalTo(self.noteLabel.snp_bottom).offset(4)
                maker.bottom.equalTo(self.contentView).offset(-8)
            }

            didSetupConstraints = true
        }
    }
}
