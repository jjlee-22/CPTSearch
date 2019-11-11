//
//  TableViewController.swift
//  CPTSearch
//
//  Created by Truc Tran  on 10/3/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit


// MARK: - global variables

var CPTCodeData = [String]() // stores all CPT codes
var shortData = [String]() // stores all CPT short descriptions
var longData = [String]() // stores all CPT long descriptions
var CPTDictionary = [String: [String]]() // stores key->value(s) pairs

var orderIndex = 0 // tracks index location of each order
var indexTrackerforLongdescription = 0 // tracks index location of CPT long description
var indexTrackerforCPTCode = 0 // tracks index location of CPT code
var dictionaryIndex = 0 //keeps track of index location of orderList
var alphabeticalBoolean = true

// map CPTDictionary to easily obtain each component
var orderList = CPTDictionary.map {(CPTCode: $0.key,
                                    Short: $0.value.first ?? "",
                                    Long:  $0.value.dropFirst().first ?? "")}

//sort short description alphabetically in descending order
let sortedDictionary = orderList.sorted(by: { $0.Short < $1.Short })

// MARK: - UITableViewCell

// customized row in UITableView: includes 2 labels
class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet var CPTCodeLabel: UILabel!
    @IBOutlet var CPTShortDescriptionLabel: UILabel!
}

// MARK: - UITableViewController
class TableViewController: UITableViewController {
    @IBOutlet var catalogTableview: UITableView!
    
    @IBOutlet var resultLabel: UILabel!
    
     
     //sort catalog short description alphabetically
     @IBAction func sortButton(_ sender: Any) {
         alphabeticalBoolean = !alphabeticalBoolean
         catalogTableview.reloadData()
     }
    
// loads content of catalog page
    override func viewDidLoad() {
        super.viewDidLoad()
        // cuztomize row height of table
        catalogTableview.rowHeight = 80.0
        loadData()
        resultLabel.text = "\(dictionaryIndex) results"
    }
    
    func loadData() {
        CPTCodeData.removeAll()
        shortData.removeAll()
        longData.removeAll()
        orderList.removeAll()
        indexTrackerforLongdescription = 0
        indexTrackerforCPTCode = 0
        dictionaryIndex = 0
        
        // obtains Orders.plist
        let url = Bundle.main.url(forResource:"Orders", withExtension: "plist")!
        
        // extract plist info into arrays
        do {
            let data = try Data(contentsOf: url)
            let sections = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[Any]]
            
            // loop through each subarray of plist
            // _ defines unnamed parameter, did not need to keep track of index of each subarray
            for (_, section) in sections.enumerated() {
                // obtains all components(CPTCode, short description, and long description of a subarray
                for item in section {
                    indexTrackerforLongdescription+=1
                    // adds all CPT longDescription to longData
                    if(indexTrackerforLongdescription%3==0){
                        longData.append(item as! String)
                    }
                    else {
                        // adds all CPTCodes to CPTCodeData
                        if(indexTrackerforCPTCode%2==0) {
                            CPTCodeData.append(item as! String)
                        }
                        else { // add all CPT shortDescription to shortData
                            shortData.append(item as! String)
                        }
                        indexTrackerforCPTCode+=1
                    }
                }
                // create dictionary: CPTCodeData (key) --> shortData, longData (values)
                CPTDictionary[CPTCodeData[dictionaryIndex]] = [shortData[dictionaryIndex], longData[dictionaryIndex]]
                dictionaryIndex+=1
            }
        } catch {
            print("Error grabbing data from properly list: ", error)
        }
    }
    
    
// MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CPTCodeData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //use cell format of customized UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! HeadlineTableViewCell
        
        // Configure the cell...
        //catalog page displays CPT Code in ascending order
        if alphabeticalBoolean {
            cell.CPTCodeLabel.text = "CPT Code: \(CPTCodeData[indexPath.row])"
            cell.CPTShortDescriptionLabel.text = shortData[indexPath.row]
            return cell
        }
            // once sort button is clicked, catalog page displays CPT short description
            // alphabetically
        else  {
            cell.CPTCodeLabel.text = "CPT Code: \(sortedDictionary[indexPath.row].CPTCode)"
            cell.CPTShortDescriptionLabel.text = sortedDictionary[indexPath.row].Short
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        orderIndex = indexPath.row
        //creates connection to description page
        performSegue(withIdentifier: "segue", sender: self)
    }
    
}
