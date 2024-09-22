//
//  ViewController.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addTask(_ sender: Any) {
        let task = textfield.text!
        
        var newTask = TaskItem(name: task, isComplete: false)
        
        do {
            if let data = UserDefaults.standard.data(forKey: "taskItemArray") {
                
                var array = try JSONDecoder().decode([TaskItem].self, from: data)
                
                array.append(newTask)
                
                let encodedata = try JSONEncoder().encode(array)
                
                UserDefaults.standard.set(encodedata, forKey: "taskItemArray")
            } else {
                
                let encodedata = try JSONEncoder().encode([newTask])
                
                UserDefaults.standard.set(encodedata, forKey: "taskItemArray")
            }
                    
                    
        } catch {
            print("unable to encode \(error)")
        }
        
//        if let taskArray = UserDefaults.standard.array(forKey: "taskArray") as? [String] {
//           var array = taskArray
//            
//            array.append(task)
//            
//            UserDefaults.standard.setValue(array, forKey: "taskArray")
//            
//        } else {
//            UserDefaults.standard.setValue([task], forKey: "taskArray")
//        }
        
        textfield.text = ""
    }
    
}

