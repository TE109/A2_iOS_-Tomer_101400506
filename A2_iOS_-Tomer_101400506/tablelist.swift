import UIKit
import CoreData

class tablelist: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var table: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Products]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self;
        table.dataSource = self;
        fetchProducts()
    }
    
    func fetchProducts() {
        do {
            self.items = try context.fetch(Products.fetchRequest())
            table.reloadData()
        } catch {
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.items?[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = """
            Name: \(item?.name ?? "")
            Description: \(item?.desc ?? "")
            """
        return cell
    }
}
