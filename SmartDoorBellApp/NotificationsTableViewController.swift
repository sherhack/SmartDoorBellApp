//
//  NotificationsTableViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 14/12/2021.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseStorageUI
import SDWebImage

struct Variables {
    static var numberOfRows = 0
}

class NotificationsTableViewController: UITableViewController {
    
    @IBOutlet var filterButtons: UISegmentedControl!
    
    var dataFilter = 0
    
    var arrayNames = [String]()
    var arrayYears = [String]()
    
    var filteredData: [String]!
    
    let storage: Storage!

    
   
    required init?(coder aDecoder: NSCoder) {
        self.storage = Storage.storage()
        super.init(coder: aDecoder)
    }
    
    lazy var storageRef:StorageReference? = {
        return self.storage.reference().child("images")
    }()
    
  
   // var filteredDates: [String] = []
    
    var itemArray = [StorageReference]()
    
    
    

    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        filteredData = []
        Task { [weak self] in
            let ss = await fecthNumberOfRows()
            Variables.numberOfRows = ss
            //print("Caralho \(Variables.statsHealth)")
            self?.tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    private func fecthNumberOfRows() async -> Int {
        do {
            let ss = try await self.storage.reference().child("images").listAll().items
            return ss.count
        
        } catch {
            return 0
        }
        
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        switch dataFilter {
            case 0: return Variables.numberOfRows
            case 1: return Variables.numberOfRows
            default: return Variables.numberOfRows
        }
    
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! NotificationsTableViewCell

        if let unwrappedStorage = storageRef {
            unwrappedStorage.listAll { [self] (result, error) in
                if let error = error {
                    print(error)
                }
                for item in result.items {
                    
                    guard let image: StorageReference? = item else { return }
                    
                    arrayYears.append(getDate(image: image!.name))
                    
                    //itemsArray.append(item)
                    
                    itemArray.append(image!)
                }
                //filteredData = arrayYears
                /*cell.titleText.text = arrayYears[indexPath.row]
                itemArray.reverse()
                cell.personImage.sd_setImage(with: itemArray[indexPath.row])*/
                
                var list = [StorageReference]()
                var listNamesFiltered = [String]()
                switch dataFilter {
                    case 0:
                        list = itemArray.reversed()
                        listNamesFiltered = arrayYears.reversed()
                    case 1:
                        list = itemArray
                        listNamesFiltered = arrayYears
                    default:
                        list = itemArray.reversed()
                        listNamesFiltered = arrayYears.reversed()
                        
                        
                }
                cell.titleText.text = listNamesFiltered[indexPath.row]
                cell.personImage.sd_setImage(with: list[indexPath.row])
                
            }
        }
        
       return cell
    }
    

    @IBAction func filterByOrder(_ sender: Any) {
        
        switch filterButtons.selectedSegmentIndex {

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
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
   
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    func getDate(image: String) -> String {

        var lowerBound = image.index((image.startIndex), offsetBy: 6)
        var upperBound = image.index((image.startIndex), offsetBy: 10)
        let year = image[lowerBound..<upperBound]



        lowerBound = image.index((image.startIndex), offsetBy: 11)
        upperBound = image.index((image.startIndex), offsetBy: 13)
        let month = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 14)
        upperBound = image.index((image.startIndex), offsetBy: 16)
        let day = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 17)
        upperBound = image.index((image.startIndex), offsetBy: 19)
        let hour = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 20)
        upperBound = image.index((image.startIndex), offsetBy: 22)
        let minute = image[lowerBound..<upperBound]

        lowerBound = image.index((image.startIndex), offsetBy: 23)
        upperBound = image.index((image.startIndex), offsetBy: 25)
        let second = image[lowerBound..<upperBound]




        // making string in date formate "YYYY-MM-DD h:m:s"



        let dateString = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second
        return dateString
    }
    
    func getDatesByOrder(dates: [String]) {
        print(dates.sorted(by: { $0.compare($1) == .orderedDescending }))
    }
    
    

}
