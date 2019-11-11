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


