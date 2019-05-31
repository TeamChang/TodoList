//
//  ViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 28/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        
        didSet {
            loadItems()
        }
    }
    
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //removes separator
        tableView.separatorStyle = .none
    }
    
    //called later than viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let cellColorHex = selectedCategory?.cellColor else { fatalError() }
        
        updateNavBar(withHexCode: cellColorHex)
    }
    
    //called just before current view controller gets destroyed
    override func viewWillDisappear(_ animated: Bool) {
        
        //updateNavBar(withHexCode: "#941751")
    }
    
    //MARK: - Nav bar setup method
    func updateNavBar(withHexCode colorHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar
            else { fatalError("Navigation controller doesnt exist.") }
        
        //sets nav bar buttons color
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError() }
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.barTintColor = navBarColor
        searchBar.barTintColor = navBarColor
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:
                                                    ContrastColorOf(navBarColor, returnFlat: true)]
        
        //        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:
        //                                            ContrastColorOf(navBarColor, returnFlat: true)]
    }

    //MARK: - Table delegate methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let cellColour = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count))) {
                
                cell.backgroundColor = cellColour
                // sets textcolor to either white or black
                cell.textLabel?.textColor = ContrastColorOf(cellColour, returnFlat: true)
            }
            
//            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
//             print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            
        } else {
            
            cell.textLabel?.text = "NO items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
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
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textfield.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving context, \(error)")
                    }
                }
                
                self.tableView.reloadData()
                
            }))
        
            self.present(alert, animated: true, completion: nil)
    }
    
    //Mark: -  saved, load & delete items to path on phone
    func saveItems(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    // loads the items from saved path
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        
        if let itemsForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    
                    self.realm.delete(itemsForDeletion)
                }
            } catch {
                print("Error saving context, \(error)")
            }
        }
    }
    
}

// MARK: - Search bar method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

