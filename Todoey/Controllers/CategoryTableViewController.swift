//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by macbook on 2018-03-07.
//  Copyright © 2018 Angela Yu. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) //chemin vers FileManager ....
        
        loadCategories()  // dans la fonction on a défini un paramètre par default

    }

     //MARK: - Add New category
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
     
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
            //print(textField.text!)
            //self.tableView.reloadData()

        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        loadCategories()
        
    }
    
//MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCategory", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    //MARK: - Model Manupulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving contexttt, \(error)")
        }
        tableView.reloadData()
    }
    //MARK: delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    func loadCategories(With request : NSFetchRequest<Category> = Category.fetchRequest()) {
        // let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
            try categoryArray = context.fetch(request)
            
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
