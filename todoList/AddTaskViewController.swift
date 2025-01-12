//
//  ViewController.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var taskDeadlinePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func handleAddTask(_ sender: Any) {
        guard let taskName = taskTitleTextField.text, !taskName.isEmpty,
              let taskSubtext = taskDescriptionTextField.text, !taskSubtext.isEmpty else {
            return
        }
        
        let newTask = TaskItem(title: taskName, description: taskSubtext, deadline: taskDeadlinePicker.date)
        
        do {
            if let data = UserDefaults.standard.data(forKey: "savedTasks") {
                var array = try JSONDecoder().decode([TaskItem].self, from: data)
                array.append(newTask)
                let encodedData = try JSONEncoder().encode(array)
                UserDefaults.standard.set(encodedData, forKey: "savedTasks")
            } else {
                let encodedData = try JSONEncoder().encode([newTask])
                UserDefaults.standard.set(encodedData, forKey: "savedTasks")
            }
            
            taskTitleTextField.text = ""
            taskDescriptionTextField.text = ""
            
            navigationController?.popViewController(animated: true)
            
        } catch {
            print("Unable to encode: \(error)")
        }
    }
}
