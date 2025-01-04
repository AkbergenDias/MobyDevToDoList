//
//  ViewController.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var tasksubtext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addTask(_ sender: Any) {
        guard let taskName = textfield.text, !taskName.isEmpty,
              let taskSubtext = tasksubtext.text, !taskSubtext.isEmpty else {
            return
        }
        
        let newTask = TaskItem(name: taskName, subtext: taskSubtext)
        
        do {
            if let data = UserDefaults.standard.data(forKey: "taskItemArray") {
                var array = try JSONDecoder().decode([TaskItem].self, from: data)
                array.append(newTask)
                let encodedData = try JSONEncoder().encode(array)
                UserDefaults.standard.set(encodedData, forKey: "taskItemArray")
            } else {
                let encodedData = try JSONEncoder().encode([newTask])
                UserDefaults.standard.set(encodedData, forKey: "taskItemArray")
            }
            
            textfield.text = ""
            tasksubtext.text = ""
            
            navigationController?.popViewController(animated: true)
            
        } catch {
            print("Unable to encode: \(error)")
        }
    }
}
