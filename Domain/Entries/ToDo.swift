//
//  ToDo.swift
//  Domain
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import Foundation

public struct ToDo {
    public let id: String
    public var title: String
    public var text: String
    public let createDate: Date
    
    public init(id: String, title: String, text: String, createDate: Date = Date()) {
        self.id = id
        self.title = title
        self.text = text
        self.createDate = createDate
    }
    
    public init(title: String, text: String, createDate: Date = Date()) {
        self.id = UUID().uuidString
        self.title = title
        self.text = text
        self.createDate = createDate
    }
}
