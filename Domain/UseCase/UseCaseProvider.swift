//
//  UseCaseProvider.swift
//  Domain
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation

public protocol IUseCaseProvider {
    func makeToDoUseCase() -> IToDoUseCase
}
