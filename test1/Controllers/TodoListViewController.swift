//
//  ViewController.swift
//  test1
//
//  Created by BossmediaNT on 04/12/18.
//  Copyright © 2018 swarnabh. All rights reserved.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController{
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
       loadItems()
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for:indexPath)
        let item=itemArray[indexPath.row]
        cell.textLabel?.text=item.title

        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happens when user clicks the Add item button
            
            let newItem = Item(context: self.context)
            newItem.title=textField.text!
            newItem.done=false
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder="Create new item."
            textField=alertTextField
            
        }
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems() {
       
        do{
        try context.save()
        } catch{
           print("Error saving context,\(error)")
        }
        self.tableView.reloadData()
    }
    
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch{
//                print("Error decoding!")
//            }
//        }
//    }
    
    func loadItems(request:NSFetchRequest<Item>=Item.fetchRequest()){
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("Error in fetching data!,\(error)")
        }
        tableView.reloadData()
}
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        let sortDescriptor=NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors=[sortDescriptor]
        loadItems(request:request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            //searchBar.resignFirstResponder()
        }
    }
    
}

