//
//  ToDoEditViewModel.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

class ToDoEditViewModel: ViewModelType  {
    
    private let useCase: IToDoUseCase
    private weak var navigator: IToDoListNavigator!
    private let id: String
    private var isEditState: Bool = false
    private var toDo: ToDo!
    
    init(_ id: String, useCase: IToDoUseCase, navigator: IToDoListNavigator) {
        self.useCase = useCase
        self.id = id
        self.navigator = navigator
    }
    
    func transform(input: ToDoEditViewModel.Input) -> ToDoEditViewModel.Output {
        let toDoDriver = input.viewWillAppearDriver
            .asObservable()
            .withLatestFrom(useCase.toDo(id: id))
            .do(onNext: {[unowned self] (toDo) in
                self.toDo = toDo
            })
            .asDriverOnErrorJustComplete()
        
        let titleDriver = toDoDriver.map{ $0.title as? String }
        let textDriver = toDoDriver.map{ $0.text as? String }
        let editinEnableDriver = input.editSaveButtonTapDriver
            .do(onNext: {[unowned self] (_) in
                self.isEditState = !self.isEditState
            })
            .map{ [unowned self] in self.isEditState}
        
        let saveObservable = editinEnableDriver
            .asObservable()
            .filter{ $0 == false}
            .flatMapLatest({[unowned self] (_) in
                return self.useCase.saveToDo(self.toDo)
            })
        
        let editSaveButtonTitleDriver = editinEnableDriver
            .asObservable()
            .map{(isEditEnable) in
               ( isEditEnable ? "Сохранить" : "Изменить") as? String
            }
            .asDriverOnErrorJustComplete()
        
        let deleteDriver = input.deleteTapDriver
            .asObservable()
            .flatMapLatest({[unowned self] in
                self.useCase.deleteToDo(self.toDo)
            }).do(onNext: {[unowned self] (_) in
                self.navigator.toToDoList()
            })
        
        let titleEditDriver = input.titleDriver
            .do(onNext: {[unowned self] (title) in
                self.toDo.title = title
        })
        
        let textEditDriver = input.textdriver
            .do(onNext: {[unowned self] (text) in
                self.toDo.text = text
        })
        
        return Output(titleDriver: titleDriver,
                      textDriver: textDriver,
                      editingEnableDriver: editinEnableDriver,
                      editSaveButtonTitleDriver: editSaveButtonTitleDriver,
                      saveObservable: saveObservable,
                      deleteObservable: deleteDriver,
                      titleEditDriver: titleEditDriver,
                      textEditDriver: textEditDriver)
    }
    
    struct Input {
        let viewWillAppearDriver: Driver<(Bool)>
        let editSaveButtonTapDriver: Driver<()>
        let deleteTapDriver: Driver<()>
        let titleDriver: Driver<String>
        let textdriver: Driver<String>
    }
    
    struct Output {
        let titleDriver: Driver<String?>
        let textDriver: Driver<String?>
        let editingEnableDriver: Driver<Bool>
        let editSaveButtonTitleDriver: Driver<String?>
        let saveObservable: Observable<()>
        let deleteObservable: Observable<()>
        let titleEditDriver: Driver<String>
        let textEditDriver: Driver<String>
    }
}
