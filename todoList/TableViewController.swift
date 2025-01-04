//
//  TableViewController.swift
//  todoList
//
//  Created by Olzhas Akhmetov on 22.09.2024.
//

import UIKit

class TableViewController: UITableViewController {
    
    var arrayTask: [TaskItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            if let data = UserDefaults.standard.data(forKey: "taskItemArray") {
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
            UserDefaults.standard.removeObject(forKey: "taskItemArray")
        }
    }
    
    func saveTasks() {
        do {
            let encodedData = try JSONEncoder().encode(arrayTask)
            UserDefaults.standard.set(encodedData, forKey: "taskItemArray")
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let task = arrayTask[indexPath.row]

        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.subtext
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        detailsVC.task = arrayTask[indexPath.row]
        detailsVC.onTaskUpdated = { [weak self] updatedTask in
            guard let self = self else { return }

            self.arrayTask[indexPath.row] = updatedTask

            self.saveTasks()

            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.pushViewController(detailsVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func deleteTask(at indexPath: IndexPath) {
        arrayTask.remove(at: indexPath.row)
        saveTasks()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.deleteTask(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
