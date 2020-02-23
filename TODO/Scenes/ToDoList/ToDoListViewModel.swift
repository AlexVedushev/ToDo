//
//  ToDoListViewModel.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import Domain
import RxSwift
import RxCocoa
import RxDataSources

class ToDoListViewModel: ViewModelType {
    private let useCase: IToDoUseCase
    private let navigator: IToDoListNavigator
    
    private var toDoList: [ToDo] = []
    
    init(useCase: IToDoUseCase, navigator: IToDoListNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let sectionDriver = input.viewDidAppear
            .flatMapLatest { [unowned self] (_) in
                return self.useCase.toDoList()
                    .do(onNext: {[unowned self] (list) in
                        self.toDoList = list
                    })
                    .map{ [SectionData(items: $0)] }
                    .asDriver(onErrorJustReturn: [SectionData(items: [])])
        }
        let editToDoDriver = input.itemSelectDriver
            .do(onNext: showEditScreen)
            .map{ _ in () }
        return Output(sectionDriver: sectionDriver, editToDoDriver: editToDoDriver)
    }
    
    
    fileprivate func showEditScreen(_ index: Int) {
        let toDo = toDoList[index]
        navigator.toEditScreen(toDo.id)
    }
    
    struct Input {
        let viewDidAppear: Driver<(Bool)>
        let itemSelectDriver: Driver<Int>
    }
    
    struct Output {
        let sectionDriver: Driver<[SectionData]>
        let editToDoDriver: Driver<()>
    }
    
    
}

struct SectionData {
    var items: [ToDo]
}

extension SectionData: SectionModelType {
    typealias Item = ToDo
    
    init(original: SectionData, items: [ToDo]) {
        self = original
        self.items = items
    }
}
