//
//  CategoryViewController.swift
//  test1
//
//  Created by BossmediaNT on 10/12/18.
//  Copyright © 2018 swarnabh. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray=[Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()

    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryCell",for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
    //MARK: - TableView Manipulation Methods
    func saveCategory(){
        do{
        try context.save()
        }catch{
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Error\(error)")
            
        }
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Items
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory=Category(context: self.context)
            newCategory.name=textField.text
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder="Enter Category here"
        }
        present(alert,animated: true,completion: nil)
    }
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    
    
    
    
    

   
    

    
}