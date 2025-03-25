//
//  ViewController.swift
//  A2_iOS_-Tomer_101400506
//
//  Created by user271259 on 3/24/25.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var index = 0;
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Products]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchProducts()
    }

    func fetchProducts() {
        do {
            self.items = try context.fetch(Products.fetchRequest())
            tableView.reloadData()
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }

    
    @IBAction func forwardPress(_ sender: Any) {
        if index < (items?.count ?? 0) - 1 {
            index += 1
            fetchProducts()
        }
    }
    
    @IBAction func backwardPress(_ sender: Any) {
        if index > 0 {
            index -= 1
            fetchProducts()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let firstItem = items?[index] {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = """
            Name: \(firstItem.name ?? "")
            Price: $\(firstItem.price)
            Description: \(firstItem.desc ?? "")
            Provider: \(firstItem.provider ?? "")
            """
        } else {
            cell.textLabel?.text = "No Data Available"
        }
        
        return cell
    }

    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Product", message: "Enter the details for the new product", preferredStyle: .alert)
        
        alert.addTextField { textField in textField.placeholder = "Name" }
        alert.addTextField { textField in textField.placeholder = "Price"; textField.keyboardType = .decimalPad }
        alert.addTextField { textField in textField.placeholder = "Description" }
        alert.addTextField { textField in textField.placeholder = "Provider" }

        let submitButton = UIAlertAction(title: "Add", style: .default) { _ in
            let nameField = alert.textFields![0].text ?? ""
            let priceField = alert.textFields![1].text ?? "0"
            let descField = alert.textFields![2].text ?? ""
            let providerField = alert.textFields![3].text ?? ""

            let newProduct = Products(context: self.context)
            newProduct.name = nameField
            newProduct.price = Double(priceField) ?? 0.0
            newProduct.desc = descField
            newProduct.provider = providerField

            do {
                try self.context.save()
                self.fetchProducts()
            } catch {
                print("Failed to save product: \(error)")
            }
        }
        
        alert.addAction(submitButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
