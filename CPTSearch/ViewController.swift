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
    
    @IBOutlet weak var submit: UIButton!    
    @IBOutlet weak var attachnotesicon: UIImageView!
    @IBOutlet weak var attachnotes: UITextField!
    
    @IBAction func talk(_ sender: Any) {
        submit.isHidden = false
        attachnotes.isHidden = false
        attachnotesicon.isHidden = false
    }
    
    var FirstTableArray = [String]()
    //var SecondTableArray = [SecondTable]()


    //let backgroundImageView = UIImageView()
    @IBOutlet var regularExpressionSearch: UISearchBar!
      var currentRegularExpression = String("")
    
    //  Number of results label, Lindsey
    @IBOutlet var numberOfResultsLabel: UILabel!
    var resultsCounter = Int(0)
    let string1 = "Number of Results: "
    var string2 = ""
    
    //  Possible bugfix? Needs to be like a Singleton
    let sendValue = TableViewController();
    //sendValue.loadData();
    
      //  I added a button -Lindsey
      @IBAction func searchButton(_ sender: UIButton)
      {
        var shortData = [String]()
        resultsCounter = 0
          //  Gets ready to set the regular expression equal to the search bar text
          currentRegularExpression = regularExpressionSearch.text ?? "error"
          var test = ""
         // Checks all of the indexes in the
        //  shortData PList to see if it contains the
        //  regular expression or not.
        for index in shortData
        {
            test = index
            let hashtags = test.hashtags(currentRegularExpression: currentRegularExpression);
            //  Goes through the PList and
            //  either prints "[]" if the regular
            //  expression was not found, or "["CHEST"]"
            //  or whatever the regular expression is
            //  if it was found            print(hashtags)
            for index in hashtags
            {
                //  Only add to the results counter if
                //  a result was found at that index
                if (index != "")
                {
                    resultsCounter = resultsCounter + 1
                }
            }
            print(resultsCounter)
        }
        //numberOfResultsLabel.text =  String(resultsCounter)
        //  Concatinating strings in Swift more
        //  difficult than in Java, can't append and int
        //  to a string, need to cast first
        string2 = String(resultsCounter)
        numberOfResultsLabel.text = string1 + string2
          
      }
    
    // This method only runs after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Gets 22 everytime, getting close!
        //sendValue.loadData();
        
        //  Works! 11!
        if (CPTCodeData.isEmpty == true)
        {
            sendValue.loadData()
        }
        
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
/*
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let Cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
                //Cell.textLabel?.text = FirstTableArray[(indexPath as NSIndexPath).row]
                return Cell
                }
 */

        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            //let indexPath : IndexPath = self.tableView.indexPathForSelectedRow!
            //let DestViewController = segue.destination as! SecondTableViewController
            //let SecondTableArrayTwo = SecondTableArray[(indexPath as NSIndexPath).row]
            //DestViewController.SecondTableArray = SecondTableArrayTwo.SecondTitle
            }
    }
}




