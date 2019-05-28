//
//  ViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 28/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Timchang", "Give him money", "Repeat the process"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //Mark: - Table delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = itemArray[indexPath.row]
        
        print("row: \(row)")
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark: - Add new items button
    @IBAction func addButtonItems(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new To-do list item",
                                      message: nil,
                                      preferredStyle: .alert)
        
            alert.addTextField { (alertTextfield) in
                alertTextfield.placeholder = "Create new item"
                textfield = alertTextfield
            }
        
            alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: {(action: UIAlertAction!) in

                //what will happen once the user clicks the add button item on alert
                print(textfield)
                self.itemArray.append(textfield.text!)
                
                self.tableView.reloadData()
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
}

