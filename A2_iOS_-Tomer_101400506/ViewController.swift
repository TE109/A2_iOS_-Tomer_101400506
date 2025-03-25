//
//  ViewController.swift
//  A2_iOS_-Tomer_101400506
//
//  Created by user271259 on 3/24/25.
//

import UIKit
import CoreData

// https://www.youtube.com/watch?v=O7u9nYWjvKk&t=2344s
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return items?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = self.items?[indexPath.row]
        cell.textLabel?.text = item?.name
        //cell.textLabel?.text = "Placeholder"
        return cell
    }
    
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    var items:[Products]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        fetchProducts()
    }
    
    
    
    func fetchProducts() {
        do {
            self.items = try context.fetch(Products.fetchRequest())
            
            tableView.reloadData()
        } catch {
            
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Product", message: "Enter the details for the new product", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Price"
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Description"
        }
        alert.addTextField { textField in
            textField.placeholder = "Provider"
        }
        let submitButton = UIAlertAction(title: "Add", style: .default) { _ in
            let nameField = alert.textFields![0].text ?? ""
            let priceField = alert.textFields![1].text ?? "0"
            let descField = alert.textFields![2].text ?? ""
            let ProviderField = alert.textFields![3].text ?? ""
            
            
            let newProduct = Products(context: self.context)
            newProduct.name = nameField
            newProduct.price = Double(priceField) ?? 0.0
            newProduct.desc = descField
            newProduct.provider = ProviderField
            
            do {
                try self.context.save()
                self.fetchProducts()
            } catch {
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitButton)
        alert.addAction(cancelButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
