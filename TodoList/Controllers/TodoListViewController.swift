//
//  ViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 28/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItemsFromPath()
        }
    }
    
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       loadItemsFromPath()
        
        //loadItemsFromPath()
//        if let items = defaults.array(forKey: "todoListArray") as? [Item] {
//            itemArray = items
//        }
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //sets done property on current item to opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItemsToPath()
        
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
                
                let newItem = Item(context: self.context)
                
                newItem.title = textfield.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                // self.defaults.set(self.itemArray, forKey: "todoListArray")
                self.saveItemsToPath()
                
                
                
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
    // saved items to path on phone
    func saveItemsToPath() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    // loads the items from saved path
    func loadItemsFromPath(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK: - Search bar method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors =  [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemsFromPath(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            
            loadItemsFromPath()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

