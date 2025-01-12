//
//  TaskItem.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import Foundation

struct TaskItem: Codable {
    var title: String
    var description: String
    var deadline: Date
}
