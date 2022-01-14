//
//  OrdersTableViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 11/01/2022.
//

import UIKit
import FirebaseStorage
import Firebase

struct NumberOfRows {
    static var numberOfRows = 0
}

class OrdersTableViewController: UITableViewController {
    
    @IBOutlet var orderBySegmentedControl: UISegmentedControl!
    
    var storageRef: StorageReference!
    
    var ordersArray = [StorageReference]()
    
    var arrayNames = [String]()
    
    var dataFilter = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = Storage.storage().reference().child("orders")
        
        Task { [weak self] in
            let ss = await fecthNumberOfRows()
            NumberOfRows.numberOfRows = ss
            //print("Caralho \(Variables.statsHealth)")
            self?.tableView.reloadData()
        }
        
        // initializing the refreshControl
        tableView.refreshControl = UIRefreshControl()
        
        // add target to UIRefreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshOrders), for: .valueChanged)
        
    }
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [weak self] in
            let ss = await fecthNumberOfRows()
            NumberOfRows.numberOfRows = ss
            //print("Caralho \(Variables.statsHealth)")
            self?.tableView.reloadData()
        }
    }*/
    
    @objc private func refreshOrders(_ sender: Any) {
        // Fetch Data
        fetchData()
    }
    
    private func fetchData() {
        if let unwrappedStorage = storageRef {
            unwrappedStorage.listAll { [self] (result, error) in
                if let error = error {
                    print(error)
                }
                for item in result.items {
                    // The items under storageReference.
                   
                    let nameOfImage = item.name.replacingOccurrences(of: ".png", with: "")
                    
                    arrayNames.append(nameOfImage)
                    
                    ordersArray.append(item)
                }
                
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NumberOfRows.numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath) as! OrdersTableViewCell
        
        
        if let unwrappedStorage = storageRef {
            unwrappedStorage.listAll { [self] (result, error) in
                if let error = error {
                    print(error)
                }
                for item in result.items {
                    // The items under storageReference.
                   
                    let nameOfImage = item.name.replacingOccurrences(of: ".png", with: "")
                    
                    arrayNames.append(nameOfImage)
                    
                    ordersArray.append(item)
                }
                
                var listAux = [StorageReference]()
                var listNamesFiltered = [String]()
                switch dataFilter {
                    case 0:
                        listAux = ordersArray.reversed()
                        listNamesFiltered = arrayNames.reversed()
                    case 1:
                        listAux = ordersArray
                        listNamesFiltered = arrayNames
                    default:
                        listAux = ordersArray.reversed()
                        listNamesFiltered = arrayNames.reversed()
                        
                }
                cell.nameOrders.text = listNamesFiltered[indexPath.row]
                cell.ordersImage.sd_setImage(with: listAux[indexPath.row])
            }
            
        }
        
        return cell

    }
    


    private func fecthNumberOfRows() async -> Int {
        do {
            let items = try await self.storageRef.listAll().items
            return items.count
        
        } catch {
            return 0
        }
        
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func orderBy(_ sender: Any) {
        
        switch orderBySegmentedControl.selectedSegmentIndex {

              case 0:
                  dataFilter = 0
                break
              case 1:
                  dataFilter = 1
                break
              default:
                  dataFilter = 0
                break
          }
          reload()
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    
    


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
