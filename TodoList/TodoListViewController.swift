//
//  ViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 28/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Timchang", "Give him money", "Repeat the process"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

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
        
//        let alert = UIAlertController(title: "Mark Request as resolved",
//                                      message: "are you sure your request has been resolved?",
//                                      preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
//
//            self.markAsResolved(id: rowId)
//
//        }))
//        self.present(alert, animated: true, completion: nil)
        
    }

}

