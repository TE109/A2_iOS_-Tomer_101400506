import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var desInput: UITextField!
    var index = 0;
    let searchController = UISearchController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Products]?
    
    // Button Press Function
    // Looks for the first index that is equal to the value of name input text box
    // sets the Current displaying index as the returned index
    // Reloads the table
    @IBAction func nameSearchPress(_ sender: Any) {
        if let foundIndex = items?.firstIndex(where: { $0.name == nameInput.text }) {
               index = foundIndex
               tableView.reloadData()
           }
        }
    
    // Works the same as name Search Press but for the description input text box
    @IBAction func descSearchPress(_ sender: Any) {
        if let foundIndex = items?.firstIndex(where: { $0.desc == desInput.text }) {
               index = foundIndex
               tableView.reloadData()
           }
    }
    
    // Intial load
    // Intilizing tableView dataSource and Delegate
    // Fetching Products
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchProducts()
    }

    // Function to retrive items from the data base
    // if no items in the array add seed data
    // reload table
    func fetchProducts() {
        self.items = try! context.fetch(Products.fetchRequest())
        if let items = items, items.isEmpty {
            seedProducts()
        }
        tableView.reloadData()
    }

    // Function to add inital data
    // loop over an array of products and save it to the contect
    // save the context
    func seedProducts() {
        let sampleProducts = [
            ("Apple", 1.99, "Fresh red apple", "Fruit Vendor"),
            ("Laptop", 999.99, "15-inch laptop with SSD", "Tech Store"),
            ("Coffee", 3.49, "Premium dark roast coffee", "Café Deluxe")
        ]
        for (name, price, desc, provider) in sampleProducts {
            let newProduct = Products(context: self.context)
            newProduct.name = name
            newProduct.price = price
            newProduct.desc = desc
            newProduct.provider = provider
        }
        try! context.save()
    }
    
    // Button function to go to next adress if it exsists
    @IBAction func forwardPress(_ sender: Any) {
        if index < (items?.count ?? 0) - 1 {
            index += 1
            fetchProducts()
        }
    }
    
    // Button function to go to previous adress if it exsists
    @IBAction func backwardPress(_ sender: Any) {
        if index > 0 {
            index -= 1
            fetchProducts()
        }
    }
    
    // How many rows in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // How to dislay the cell
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
                
            }
        }
        
        alert.addAction(submitButton)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
