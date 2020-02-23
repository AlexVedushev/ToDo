//
//  Reactive+extension.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
      return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
      let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
    }
}
