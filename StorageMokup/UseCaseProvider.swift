//
//  UseCaseProvider.swift
//  StorageMokup
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation
import Domain

public final class UseCaseProvider: Domain.IUseCaseProvider {
    public init() { }
    
    public func makeToDoUseCase() -> IToDoUseCase {
        return ToDoUseCaseImplementation()
    }
    
    
}
