//
//  ToDoListNavigator.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import Domain

protocol IToDoListNavigator: class {
    func toToDoList()
    func toEditScreen(_ id: String)
}

class ToDoListNavigator: IToDoListNavigator {
    private let storyboard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: IUseCaseProvider
    
    func getNavigationController() -> UINavigationController {
        return navigationController
    }
    
    init(storyboard: UIStoryboard,
         services: IUseCaseProvider) {
        self.services = services
        self.storyboard = storyboard
        let vc = storyboard.instantiateViewController(identifier: String(describing: ToDoListVC.self)) as! ToDoListVC
        self.navigationController = UINavigationController(rootViewController: vc)
        
        let viewModel = ToDoListViewModel(useCase: services.makeToDoUseCase(), navigator: self)
        vc.viewModel = viewModel
    }
    
    func toEditScreen(_ id: String) {
        let vc = storyboard.instantiateViewController(identifier: String(describing: ToDoEditScreenVC.self)) as! ToDoEditScreenVC
        let useCase = services.makeToDoUseCase()
        let viewModel = ToDoEditViewModel(id, useCase: useCase, navigator: self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toToDoList() {
        navigationController.popViewController(animated: true)
    }
    
    
}
