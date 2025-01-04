//
//  DetailsViewController.swift
//  todoList
//
//  Created by Диас Акберген on 04.12.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    var task: TaskItem?
    var onTaskUpdated: ((TaskItem) -> Void)?
    
    private let taskNameTextField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        taskNameTextField.translatesAutoresizingMaskIntoConstraints = false
        taskNameTextField.borderStyle = .roundedRect
        taskNameTextField.textAlignment = .center
        taskNameTextField.font = UIFont.systemFont(ofSize: 18)
        taskNameTextField.text = task?.name
        
        view.addSubview(taskNameTextField)
        
        NSLayoutConstraint.activate([
            taskNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            taskNameTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTaskName))
    }
    
    @objc private func saveTaskName() {
        guard let newName = taskNameTextField.text, !newName.isEmpty else {
                    return
                }
        if let newName = taskNameTextField.text, !newName.isEmpty, var task = task {
            task.name = newName
            self.task = task
            
            onTaskUpdated?(task)
            navigationController?.popViewController(animated: true)
        }
    }
}
