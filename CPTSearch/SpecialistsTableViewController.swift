//
//  SpecialistsTableViewController.swift
//  CPTSearch
//
//  Created by Jhoonil on 12/2/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

extension SpecialistsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

class SpecialistsTableViewController: UITableViewController {

    //MARK: Properties
    var specialists = [Specialists]()
    var filteredSpecialists: [Specialists] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data
        loadSpecialists()
        
        // UISearchController property
        //let searchController = UISearchController(searchResultsController: nil)
        
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Specialists"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        // isSearchBarEmpty returns true if the next typed in the search bar is empty; otherwise, it returns false
        /*var isSearchBarEmpty: Bool {
            return searchController.searchBar.text?.isEmpty ?? true
        }
        
        var isFiltering: Bool {
            return searchController.isActive && !isSearchBarEmpty
        }*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredSpecialists.count
        }
        
        return specialists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "SpecialistsTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SpecialistsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of SpecialistsTableViewCell")
        }
        
        var specialist = specialists[indexPath.row]
        
        if isFiltering {
            specialist = filteredSpecialists[indexPath.row]
        } else {
            specialist = specialists[indexPath.row]
        }
        
        // Configure cell
        cell.first.text = specialist.firstname
        cell.last.text = specialist.lastname
        cell.depart.text = specialist.department
        cell.email.text = specialist.email
        cell.phone.text = specialist.phonenumber
        

        return cell
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredSpecialists = specialists.filter { (specialists: Specialists) -> Bool in
            return specialists.firstname.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
    
    //MARK: Private Methods
    private func loadSpecialists() {
        guard let specialist1 = Specialists(firstname: "Truc", lastname: "Herman", department: "Radiology", email: "TrucHerman@jcu.edu", phonenumber: "216-888-8888") else {
            fatalError("Unable to load specialist")
        }
        
        guard let specialist2 = Specialists(firstname: "Shelbi", lastname: "Shearer", department: "Human Resource", email: "ssh@jcu.edu", phonenumber: "216-000-0000") else {
            fatalError("Unable to load specialist")
        }
        
        guard let specialist3 = Specialists(firstname: "Jonathan", lastname: "Lee", department: "Morale Support Team", email: "jonlee@jcu.edu", phonenumber: "540-123-4512") else {
            fatalError("Unable to load specialist")
        }
        
        guard let specialist4 = Specialists(firstname: "Jane", lastname: "Doe", department: "IT", email: "janedoe@jcu.edu", phonenumber: "000-000-0000") else {
            fatalError("Unable to load specialist")
        }
        
        guard let specialist5 = Specialists(firstname: "Dan", lastname: "PamPam", department: "Writing Dept.", email: "pampampam@jcu.edu", phonenumber: "999-666-2222") else {
            fatalError("Unable to load specialist")
        }
        
        guard let specialist6 = Specialists(firstname: "Copy", lastname: "Paste", department: "Law", email: "copypaste@jcu.edu", phonenumber: "111-111-1111") else {
            fatalError("Unable to load specialist")
        }
        
        specialists += [specialist1, specialist2, specialist3, specialist4, specialist5, specialist6, specialist6, specialist6, specialist6, specialist6, specialist6, specialist6]
    }

}
