//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 29/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
       
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.cellColor)
                else { fatalError() }
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Yet"
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].cellColor ?? "#941751")
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }

    // MARK: - Data manipulation methods
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        //loads all categories in database
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {

                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error saving context, \(error)")
            }
        }
    }
    
    // MARK: - Add new categories
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Category list",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new category"
            textfield = alertTextfield
        }
        
        alert.addAction(UIAlertAction(title: "Add Category", style: .default, handler: {(action: UIAlertAction!) in
            
            //what will happen once the user clicks the add button item on alert
            
            let newCategory = Category()
            
            newCategory.name = textfield.text!
            newCategory.cellColor = UIColor.randomFlat.hexValue()
            
            self.saveCategories(category: newCategory)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

////MARK: - Swipe cell delegate method
//extension CategoryViewController: SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//
//                do {
//                    try self.realm.write {
//
//                        self.realm.delete(categoryForDeletion)
//                    }
//                } catch {
//                    print("Error saving context, \(error)")
//                }
//            }
//        }
//
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//
//        return options
//    }
//}
