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

class NotificationsTableViewController: UITableViewController {
    
    var arrayNames = [String]()
    var arrayYears = [String]()
    
    
    private var number: Int = 0
    
    fileprivate var numberOfRows: Int?
  
    
    
    let name = [
    "dsdsd", "asdsfdsf", "sdfsdf", "yhjthh"]


    let storage: Storage!

    
    required init?(coder aDecoder: NSCoder) {
        self.storage = Storage.storage()
        super.init(coder: aDecoder)
    }
    
    lazy var storageRef:StorageReference? = {
        return self.storage.reference().child("images")
    }()
    
  
    
    var yourArray = [StorageReference]()
    
    var itemsArray = [StorageReference]()
    
    var itemsArray1 = [StorageReference]()
   
    //var itemsArray:Int? = nil
    
    
    var result2: Int = 0
    
    var result3: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        /*Task(priority: .medium) {
           do {
               let result = try await saveChanges()
               print(result)
           } catch {
               print(error)
           }
        }*/
       
    }
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task(priority: .medium) {
           do {
               let result = try await saveChanges()
               print(result)
           } catch {
               print(error)
           }
        }
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.storage.reference().child("images").listAll(completion: {
                 (result,error) in
                   print("result is \(result.items)")
                    self.itemsArray = result.items
                             DispatchQueue.main.async {
                               self.itemsArray.forEach({ (refer) in
                                   self.itemsArray1.append((refer))
                               })
                             }
                         })
    }
        
      
    
    


    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return itemsArray1.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! NotificationsTableViewCell

        // Configure the cell...
        //cell.titleText.text = name[indexPath.row]
        //cell.personImage.image = UIImage(named: "image1")
        //cell.descText.text = "Ganda bacalhau"
        
       
        
        if let unwrappedStorage = storageRef {
            unwrappedStorage.listAll { [self] (result, error) in
                if let error = error {
                    print(error)
                }
                //result.items.count
                for prefix in result.prefixes {
                    // The prefixes under storageReference.
                    // You may call listAll(completion:) recursively on them.
                    print("Prefixessssssss:  \(prefix)")
                }
                for item in result.items {
                    // The items under storageReference.
                    print("ITEMMMMM: \(item)")
                    //var image: StorageReference?
                    guard let image: StorageReference? = item else { return }
                    //print("AHAHAHAHAHHAHAAAH: \(String(describing: image?.name.suffix(29)))")
                    
                    let name = String(describing: image!.name.suffix(29))
                    
                    arrayNames.append(name)
                    //var year = name[NSRange(location: 7, length: 4)]
                    arrayYears.append(getDate(image: image!.name))
                    
                    yourArray.append(image!)
                }
                cell.titleText.text = arrayYears[indexPath.row]
                
                cell.personImage.sd_setImage(with: result.items[indexPath.row])
                self.numberOfRows = yourArray.count
            
            }
            
        }
        return cell
    }
    
  
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

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
    
    func getDate(image: String) -> String {

    var lowerBound = image.index((image.startIndex), offsetBy: 6)
    var upperBound = image.index((image.startIndex), offsetBy: 10)
    var year = image[lowerBound..<upperBound]



    lowerBound = image.index((image.startIndex), offsetBy: 11)
    upperBound = image.index((image.startIndex), offsetBy: 13)
    var month = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 14)
    upperBound = image.index((image.startIndex), offsetBy: 16)
    var day = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 17)
    upperBound = image.index((image.startIndex), offsetBy: 19)
    var hour = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 20)
    upperBound = image.index((image.startIndex), offsetBy: 22)
    var minute = image[lowerBound..<upperBound]

    lowerBound = image.index((image.startIndex), offsetBy: 23)
    upperBound = image.index((image.startIndex), offsetBy: 25)
    var second = image[lowerBound..<upperBound]




    // making string in date formate "YYYY-MM-DD h:m:s"



    let dateString = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second
    return dateString
    }
    
    
    func returnNumberImages() -> Int {
        
        return number
    }
   

}
