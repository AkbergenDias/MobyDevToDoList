//
//  TableViewController.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    var arrayTask: [TaskItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            if let data = UserDefaults.standard.data(forKey: "savedTasks") {
                print("Found saved data")
                let array = try JSONDecoder().decode([TaskItem].self, from: data)
                print("Successfully decoded \(array.count) tasks")
                arrayTask = array
                tableView.reloadData()
            } else {
                print("No saved data found")
            }
        } catch {
            print("Decoding error details: \(error)")
            UserDefaults.standard.removeObject(forKey: "savedTasks")
        }
    }
    
    func saveTaskList() {
        do {
            let encodedData = try JSONEncoder().encode(arrayTask)
            UserDefaults.standard.set(encodedData, forKey: "savedTasks")
        } catch {
            print("Unable to encode: \(error)")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTask.count
    }
// CUSTOMIZATION, LEARN LATER MORE
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let task = arrayTask[indexPath.row]
        //LEft Side
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.description
        cell.detailTextLabel?.numberOfLines = 1
        //Right Side What a mess omg
        let formatter = DateFormatter()
         formatter.dateStyle = .medium
         formatter.timeStyle = .none
         let deadlineString = formatter.string(from: task.deadline)
         let countdown = timeRemaing(to: task.deadline)
        
        let rightLabel = UILabel()
        rightLabel.text = "\(deadlineString)\n(\(countdown))"
        rightLabel.textAlignment = .right
        rightLabel.numberOfLines = 2
        rightLabel.sizeToFit()
        
        cell.accessoryView = rightLabel

        
        return cell
    }
    // here we show how much time is remaining until stuff happens
    func timeRemaing (to deadline: Date) -> String {
        let now = Date()
        let timeInterval = deadline.timeIntervalSince(now)
        
        if timeInterval <= 0 {
            return "Overdue"
        }
        let days = Int(timeInterval) / (60 * 60 * 24)
            let months = days / 30
            let weeks = (days % 30) / 7
            let remainingDays = days % 7
            
            if months > 0 {
                return "\(months) months remaining"
            } else if weeks > 0 {
                return "\(weeks) weeks, \(remainingDays) days remaining"
            } else {
                return "\(remainingDays) days remaining"
            }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this thing is the reason why  VC crashed whie tapping aka didselectRowAt and showed nill on title desc date etc
        if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsViewController {

        detailsVC.task = arrayTask[indexPath.row]
        detailsVC.onTaskUpdated = { [weak self] updatedTask in
            guard let self = self else { return }
            
            self.arrayTask[indexPath.row] = updatedTask
            self.saveTaskList()
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func removeTask(at indexPath: IndexPath) {
        arrayTask.remove(at: indexPath.row)
        saveTaskList()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.removeTask(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
