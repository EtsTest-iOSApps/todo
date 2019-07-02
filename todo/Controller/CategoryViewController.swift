//
//  CategoryViewController.swift
//  todo
//
//  Created by Manu on 02/06/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let emptyTitle = "You don't have any categories."
    let emptyMessage = "Use the '+' top right button to add one."

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelectionDuringEditing = false
        navigationItem.leftBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.barTintColor = self.view.tintColor
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCategories()
    }

    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories?.isEmpty ?? true {
            tableView.setEmptyMessage(title: emptyTitle, message: emptyMessage)
            setEditing(false, animated: false)
        } else {
            tableView.removeEmptyMessage()
        }
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.title
            cell.detailTextLabel?.text = category.subtitle
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categories?.isEmpty ?? true {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if (categories?[indexPath.row]) != nil {
                performSegue(withIdentifier: "showItemsSegue", sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*cell.detailTextLabel?.textColor = self.view.tintColor
         cell.detailTextLabel?.backgroundColor = self.view.tintColor
         cell.detailTextLabel?.layer.masksToBounds = true
         cell.detailTextLabel?.layer.cornerRadius = 5*/
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let category = self.categories?[indexPath.row] {
                self.delete(category: category)
                self.tableView.reloadData()
                completion(true)
            }
        }
        delete.image = UIImage(named: "delete-icon")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    //MARK: - Naviguation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemsSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let category = categories?[indexPath.row] {
                    let itemViewController = segue.destination as! ItemViewController
                    itemViewController.category = category
                }
            }
        }
    }
    
    
    //MARK: - Data manipulation Methods
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func insert(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error inserting category with Realm \(error)")
        }
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error deleting category with Realm \(error)")
        }
    }
    
    
    //MARK: - Other Methods
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        createCategory()
    }
    
    func createCategory() {
        let alert  = UIAlertController(title: "New category", message: "", preferredStyle: .alert)
        var titleTextField = UITextField()
        var subtitleTextField = UITextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            
            let category = Category()
            category.title = titleTextField.text!
            category.subtitle = subtitleTextField.text!
            
            self.insert(category: category)
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
            titleTextField = textField
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Subtitle"
            subtitleTextField = textField
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


//MARK: - UINavigationController StatusBarStyle override
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
