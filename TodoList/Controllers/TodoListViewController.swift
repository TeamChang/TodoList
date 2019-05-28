//
//  ViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 28/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = Item()
        newItem.title = "Find Timchang"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "Give him money"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "Repeat the process"
        itemArray.append(newItem3)
        
        
        if let items = defaults.array(forKey: "todoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    //Mark: - Table delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = itemArray[indexPath.row]
        
        print("row: \(row)")
        //sets done property on current item to opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
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
                let newItem = Item()
                newItem.title = textfield.text!
                self.itemArray.append(newItem)
                
                self.defaults.set(self.itemArray, forKey: "todoListArray")
                
                self.tableView.reloadData()
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
}

