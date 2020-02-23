//
//  ToDoUseCaseImplemenation.swift
//  StorageMokup
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public class ToDoUseCaseImplementation: IToDoUseCase {
    fileprivate let scheduler: ImmediateSchedulerType
    fileprivate var toDoArray: [ToDo] {
        Storage.shared.toDoList
    }
    
    
    public init() {
        scheduler = SerialDispatchQueueScheduler(qos: DispatchQoS.userInitiated)
    }
    
    public func toDoList() -> Observable<[ToDo]> {
        return Observable.deferred {
            return Observable.just(self.toDoArray)
        }.subscribeOn(scheduler)
    }
    
    public func toDo(id: String) -> Observable<ToDo> {
        return Observable.deferred {
            Observable.create { observer in
                if let obj = self.toDoArray.first(where: { $0.id == id }) {
                    observer.onNext(obj)
                } else {
                    observer.onError(UseCaseError.notFound)
                }
                return Disposables.create()
            }
            }.subscribeOn(scheduler)
    }
    
    public func saveToDo(_ toDo: ToDo) -> Observable<Void> {
        Observable.deferred {
            Observable.create { observer in
                if let index = self.toDoArray.firstIndex(where: { $0.id == toDo.id }) {
                     Storage.shared.toDoList[index] = toDo
                } else {
                     Storage.shared.toDoList.append(toDo)
                }
                observer.onNext(())
                return Disposables.create()
            }
        }.subscribeOn(scheduler)
    }
    
    public func deleteToDo(_ toDo: ToDo) -> Observable<Void> {
        Observable.deferred {
            Observable.create { observer in
                if let index = self.toDoArray.firstIndex(where: { $0.id == toDo.id }) {
                     Storage.shared.toDoList.remove(at: index)
                }
                observer.onNext(())
                return Disposables.create()
            }
        }
    }
}

class Storage {
    static let shared = Storage()
    
    var toDoList = [
        ToDo(title: "Купить продукты", text: "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "),
        ToDo(title: "Продать продукты", text: "Текст Текст Текст Текст "),
        ToDo(title: "Съесть продукты", text: "Текст Текст Текст Текст ")]
}
