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
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var taskDeadlinePicker: UIDatePicker!
    @IBOutlet weak var saveTask: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*print("taskTitleTextField is \(taskTitleTextField == nil ? "nil" : "not nil")")
            print("taskDescriptionTextField is \(taskDescriptionTextField == nil ? "nil" : "not nil")")
            print("taskDeadlinePicker is \(taskDeadlinePicker == nil ? "nil" : "not nil")")*/
        
        //Use it for debugg
        
        taskTitleTextField.text = task?.title
        taskDescriptionTextField.text = task?.description
        taskDeadlinePicker.date = task?.deadline ?? Date()
    }
    
    @IBAction func saveTaskDetails(_ sender: UIButton) {
        guard let updatedTitle = taskTitleTextField.text, !updatedTitle.isEmpty,
              let updatedDescription = taskDescriptionTextField.text, !updatedDescription.isEmpty else {
            return
        }
        
        let updatedTask = TaskItem(
            title: updatedTitle,
            description: updatedDescription,
            deadline: taskDeadlinePicker.date
        )
        
        onTaskUpdated?(updatedTask)
        navigationController?.popViewController(animated: true)
    }
}
