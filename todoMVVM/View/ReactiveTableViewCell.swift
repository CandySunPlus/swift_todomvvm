//
// Created by niksun on 2019-01-08.
// Copyright (c) 2019 niksun. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ReactiveTableViewCell<T: ViewModelProtocol>: UITableViewCell {
    private let (signal, observer) = Signal<T, NoError>.pipe()
    var vm_signal: Signal<T, NoError> {
        return signal
    }

    class func reuseIdentifier() -> String {
        return "cn.sfmblog.ReactiveTableViewCell"
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder has not been implemented")
    }

    func bindViewModel(_ viewModel: T) {
        observer.send(value: viewModel)
        updateConstraintsIfNeeded()
        setNeedsLayout()
    }
}
