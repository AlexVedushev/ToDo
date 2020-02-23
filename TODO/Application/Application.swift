//
//  Application.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import Domain
import StorageMokup

class Application {
    static let shared = Application()
    
    private let useCaseProvider: Domain.IUseCaseProvider
    
    private init() {
        self.useCaseProvider = StorageMokup.UseCaseProvider()
    }
    
    func configureMainInterface(_ window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigator = ToDoListNavigator(storyboard: storyboard, services: useCaseProvider)
        window.rootViewController = navigator.getNavigationController()
    }
}
