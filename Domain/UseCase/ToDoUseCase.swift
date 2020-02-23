//
//  ToDoUseCase.swift
//  Domain
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation
import RxSwift

public protocol IToDoUseCase {
    func toDoList() -> Observable<[ToDo]>
    func toDo(id: String) -> Observable<ToDo>
    func saveToDo(_ toDo: ToDo) -> Observable<Void>
    func deleteToDo(_ toDo: ToDo) -> Observable<Void>
}
