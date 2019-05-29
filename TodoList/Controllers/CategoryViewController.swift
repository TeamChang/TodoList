//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Timchang Wuyep on 29/05/2019.
//  Copyright © 2019 Timchang Wuyep. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategoriesFromPath()
       
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }

    // MARK: - Data manipulation methods
    func saveCategoriesToPath() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategoriesFromPath(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()
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
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textfield.text!
            self.categoryArray.append(newCategory)
            
            // self.defaults.set(self.itemArray, forKey: "todoListArray")
            self.saveCategoriesToPath()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
