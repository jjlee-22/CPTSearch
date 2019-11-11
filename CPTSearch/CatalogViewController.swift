//
//  CatalogViewController.swift
//  CPTSearch
//
//  Created by Jonathan on 11/01/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import Foundation
import UIKit


// MARK: - global variables

var specialist_data = [String: [String]]() // id in each pairs
var first_name = [String]() // first names
var last_name = [String]() // last names
var comments = [String]() // specialist_id

var index_data = 0 // indices for id_specialist
var index_firstname = 0 // indices for firstname
var index_lastname = 0 // indices for lastname
var index_comments = 0 // indices for comments

// map CPTDictionary to easily obtain each component
var contacts = CPTDictionary.map {(index_data: $0.key,
                                    index_firstname: $0.value.first ?? "",
                                    index_lastname:  $0.value.first ?? "")}


// MARK: - UITableViewController
class CatalogViewController: UICatalogViewController {
    @IBOutlet var catalogTableview: UICatalogView!
    
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
        func getPlist(withName name: String) -> [String]?
        {
            if  let path = Bundle.main.path(forResource: name, ofType: "plist"),
                let xml = FileManager.default.contents(atPath: path)
            {
                return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String]
            }

            return nil
        }
        if let fruits = getPlist(withName: first_name) {
            print(fruits)
        }
        
        if  let path        = Bundle.main.path(forResource: "Preferences", ofType: "plist"),
            let xml         = FileManager.default.contents(atPath: path),
            let preferences = try? PropertyListDecoder().decode(Preferences.self, from: xml)
        {
            print(preferences.webserviceURL)
        }
    }
}
