//
//  ViewController.swift
//  CPTSearch
//
//  Description: CPTSearch is an iOS ordering app that searches for the correct imaging exam and processes the orders for the doctors
//
//  Created by Jonathan Lee on 9/16/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

//  This is a struct, which is like a class, but different somehow. It creates the Regular Expression -Lindsey
extension String
{
    //  A method inside of the struct
    func hashtags(currentRegularExpression:String) -> [String]
    {
        
        //if let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        //if let regex = try? NSRegularExpression(pattern: "regularExpressionSearch.text", options: .caseInsensitive)        {
        if let regex = try? NSRegularExpression(pattern: currentRegularExpression, options: .caseInsensitive){
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range)
                //  Below was for the Christmas Hashtags, don't need for medical procedures
                //.replacingOccurrences(of: "#", with: "").lowercased()
            }
        }
        //  Method returns an array of Strings that match the Regular Expression. Will be the rows of the table at some point.
        return []
    }
}
//  End of Regular Expression Struct


// MARK: - UIViewController

class ViewController: UIViewController {
    // reference to UI labels
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var CPTCodeLabel: UILabel!
    
    var FirstTableArray = [String]()
    //var SecondTableArray = [SecondTable]()


    //let backgroundImageView = UIImageView()
    @IBOutlet weak var regularExpressionSearch: UISearchBar!
      var currentRegularExpression = String("")

      
      //  I added a button -Lindsey
      @IBAction func searchButton(_ sender: UIButton)
      {
        let sendValue = TableViewController();
        sendValue.loadData();
        
          //  Gets ready to set the regular expression equal to the search bar text
          currentRegularExpression = regularExpressionSearch.text ?? "error"
          var test = ""
          //  Checks this string to see if the regular expression is contained in it or not. This string will become the entire CptLongDescriptions column of medical procdures.
        for index in shortData {
            
            test = index
            let hashtags = test.hashtags(currentRegularExpression: currentRegularExpression);
             
            print(hashtags)
        }
          //  Calls the struct (a class-like thing) to create the regular expression
          
      }
    
    // This method only runs after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // displays data according to boolean status
        if(CPTCodeData.isEmpty == false && alphabeticalBoolean == true){
               CPTCodeLabel?.text = CPTCodeData[orderIndex]
               titleLabel?.text = shortData[orderIndex]
               descriptionLabel?.text = longData[orderIndex]
        }
        if(CPTCodeData.isEmpty == false && alphabeticalBoolean == false) {
            CPTCodeLabel?.text = sortedDictionary[orderIndex].CPTCode
            titleLabel?.text = sortedDictionary[orderIndex].Short
            descriptionLabel?.text = sortedDictionary[orderIndex].Long
        }

            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.tintColor = UIColor.white

        // First Table Array

            FirstTableArray = ["Example", "Example2"]

        // Second Table Array

            //SecondTableArray = [
                //SecondTable(SecondTitle: ["Data1", "Data2", "Data3"]),
                //SecondTable(SecondTitle: ["Data4", "Data5", "Data6"]),
            //]
            

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            {
            return FirstTableArray.count
            }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
            //Cell.textLabel?.text = FirstTableArray[(indexPath as NSIndexPath).row]
            //return Cell
            }

        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //let indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
            //let DestViewController = segue.destination as! SecondTableViewController
            //let SecondTableArrayTwo = SecondTableArray[(indexPath as NSIndexPath).row]
            //DestViewController.SecondTableArray = SecondTableArrayTwo.SecondTitle
            }
    }
}




