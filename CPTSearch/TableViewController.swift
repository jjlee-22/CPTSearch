//
//  TableViewController.swift
//  CPTSearch
//
//  Created by Truc Tran  on 10/3/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

var CPTCodeData = [String]() // stores all CPT code
var shortData = [String]() // stores all CPT short description
var longData = [String]() // stores all CPT long description
var myIndex = 0; // tracks index location of each order
var indexTrackerforLongDescription = 0; // tracks index location of CPT long description
var indexTrackerforCPTCode = 0; // tracks index location of CPT code


// customized row in UITableView: includes 2 labels
class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet var CPTCodeLabel: UILabel!
    @IBOutlet var CPTShortDescriptionLabel: UILabel!
}


class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0

        let url = Bundle.main.url(forResource:"Orders", withExtension: "plist")!
        
        do {
            let data = try Data(contentsOf: url)
            let sections = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[Any]]

            for (_, section) in sections.enumerated() {
                for item in section {
                     indexTrackerforLongDescription+=1
                    if(indexTrackerforLongDescription%3==0){ // adds all CPT longDescription to longData
                       longData.append(item as! String)
                    }
                    else {
                        if(indexTrackerforCPTCode%2==0) { // adds all CPTCodes to CPTCodeData
                         CPTCodeData.append(item as! String)
                        }
                        else { // add all CPT shortDescription to shortData
                         shortData.append(item as! String)
                        }
                        indexTrackerforCPTCode+=1
                    }
                }
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
           let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! HeadlineTableViewCell

           // Configure the cell...
            cell.CPTCodeLabel.text = "CPT Code: \(CPTCodeData[indexPath.row])"
            cell.CPTShortDescriptionLabel.text = shortData[indexPath.row]
           return cell
       }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        myIndex = indexPath.row
         performSegue(withIdentifier: "segue", sender: self)
     }
}
