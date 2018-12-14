//
//  ViewController.swift
//  test1
//
//  Created by BossmediaNT on 04/12/18.
//  Copyright © 2018 swarnabh. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController{
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        if let item=todoItems?[indexPath.row]{
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items Added!"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Error updating todo,\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks the Add item button
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                currentCategory.items.append(newItem)
                }
                }catch{
                    print("Error saving new items,\(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item."
            textField=alertTextField
            
        }
        present(alert, animated: true, completion: nil)
        }
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
}

//MARK: - Search Bar Methods÷
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//        let sortDescriptor=NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors=[sortDescriptor]
//        loadItems(request:request,predicate: predicate)
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        if searchBar.text?.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//            //searchBar.resignFirstResponder()
//        }
//    }

}
