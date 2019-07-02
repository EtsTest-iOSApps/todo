//
//  ItemViewController.swift
//  todo
//
//  Created by Manu on 05/05/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {

    let realm = try! Realm()
    let emptyTitle = "You don't have any item in this category."
    let emptyMessage = "Use the '+' top right button to add one."
    let searchController = UISearchController(searchResultsController: nil)
    
    var items: Results<Item>?
    var category: Category? {
        didSet {
            loadItems()
            navigationItem.title = category?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = .white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
            /*Placeholder customization
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

            Search icon customization
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }*/
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items?.isEmpty ?? true {
            tableView.setEmptyMessage(title: emptyTitle, message: emptyMessage)
            setEditing(false, animated: true)
        } else {
            tableView.removeEmptyMessage()
        }
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating Item with Realm \(error)")
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let item = self.items?[indexPath.row] {
                self.delete(item: item)
                self.tableView.reloadData()
                completion(true)
            }
        }
        delete.image = UIImage(named: "delete-icon")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    

    //MARK: - Data Methods
    func loadItems(predicate: NSPredicate? = nil) {
        items = category?.items.sorted(byKeyPath: "created", ascending: true)
        tableView.reloadData()
    }
    
    func insert(item: Item) {
        if let c = category {
            do {
                try realm.write {
                    c.items.append(item)
                }
            } catch {
                print("Error inserting item with Realm \(error)")
            }
        }
    }
    
    func delete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error deleting item with Realm \(error)")
        }
    }
    
    
    //MARK: - Other Methods
    @IBAction func addBarButtonItemPressed(_ sender: Any) {
        createItem()
    }
    
    func createItem() {
        let alert  = UIAlertController(title: "New item", message: "", preferredStyle: .alert)
        var itemNameTextField = UITextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            
            let item = Item()
            item.title = itemNameTextField.text!
            self.insert(item: item)
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "New item name"
            itemNameTextField = textField
        }
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?[0], queue: OperationQueue.main) { _ -> Void in
            let textField = alert.textFields?[0]
            add.isEnabled = !textField!.text!.isEmpty
        }
        add.isEnabled = false
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UISearchResultsUpdating Delegate
extension ItemViewController : UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if searchText.isEmpty {
            loadItems()
        } else {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            items = category?.items.filter(predicate).sorted(byKeyPath: "created", ascending: false)
            tableView.reloadData()
        }
    }
}
