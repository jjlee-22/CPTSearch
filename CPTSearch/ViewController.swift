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
    func hashtags(currentRegularExpression:String, stringLength:String) -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: currentRegularExpression, options: .caseInsensitive)
        {
            let string = self as NSString
            //  This is for almost anything
            if (stringLength == "Full")
            {
                return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map
                {
                    string.substring(with: $0.range)
                }
            }
            /*  This is only for if everything is "Unsure" and there is no text in the textbox.
            It will find a match for every letter in every word and get like 2000 results.
            This prevents that and makes it so that it only checks the first letter of each short description
            and gets exactly one of each short description */
            else
            {
                return regex.matches(in: self, options: [], range: NSRange(location: 0, length: 1)).map
                {
                    string.substring(with: $0.range)
                }
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
    
    //  Starts as "Unsure", so searches for anything since not specified to like "W/DYE", or whatever
    var procedureSelection = String(".*")
    var contrastSelection = String(".*")
    var dyeSelection = String(".*")
    
    //  Number of results label, Lindsey
    @IBOutlet var numberOfResultsLabel: UILabel!
    var resultsCounter = Int(0)
    let string1 = "Number of Results: "
    //  Will get set to the actual number (resultsCounter) cast from Int to to String.
    var string2 = ""
    
    //  Possible bugfix? Needs to be like a Singleton
    let sendValue = TableViewController();
    //sendValue.loadData();
    
    //  Before the button, need to get the values from the Segmented Controls for like CT vs MRI
    @IBOutlet weak var procedureType: UISegmentedControl!
    @IBAction func indexChangedProcedureType(_ sender: Any)
    {
        switch procedureType.selectedSegmentIndex
        {
            case 0:
                procedureSelection = "CT .*"
            case 1:
                procedureSelection = "MRI* .*"
            case 2:
                procedureSelection = ".*"
            default:
                 break
            
        }
    }

    @IBOutlet weak var contrast: UISegmentedControl!
    
    @IBAction func indexChangedContrast(_ sender: Any)
    {
        switch contrast.selectedSegmentIndex
        {
            case 0:
                contrastSelection = ".*W/CONTRAST"
            case 1:
                contrastSelection = ".*W/O.*CONTRAST"
            case 2:
                contrastSelection = ".*"
            default:
                break
        }
    }

    @IBOutlet weak var dye: UISegmentedControl!
    @IBAction func indexChangedDye(_ sender: Any)
    {
        switch dye.selectedSegmentIndex
        {
            case 0:
                //dyeSelection = ".*W *(OR)* */DYE"
                //dyeSelection = ".*W/0!.*/DYE"
                //  Want "W", then anything except "/O", then "/DYE"
                //dyeSelection = ".*W/DYE||.*W/!0!.*DYE"
                //  Need a single | for "OR" in Regular Expressions!
                dyeSelection = ".*W/DYE|.*W OR.*DYE"
            case 1:
                dyeSelection = ".*W/O.*DYE"
            case 2:
                dyeSelection = ".*"
            default:
                 break
        }
    }
    
      //  I added a button -Lindsey
      @IBAction func searchButton(_ sender: UIButton)
      {
        
        print("Beginning of one search:")
        print()
        
        
        resultsCounter = 0
        //  Gets ready to set the regular expression equal to the search bar text
        currentRegularExpression = regularExpressionSearch.text ?? "error"
        
        currentRegularExpression = procedureSelection + currentRegularExpression + contrastSelection + dyeSelection
        //currentRegularExpression = procedureSelection + "([A-Z+] )*" + currentRegularExpression
        //currentRegularExpression = procedureSelection + " " + "[a-z0-9]*" + currentRegularExpressio
        
        
        
       
        var test = ""
         // Checks all of the indexes in the
        //  shortData PList to see if it contains the
        //  regular expression or not.
        for index in shortData
        {
            test = index
            
            var hashtags = test.hashtags(currentRegularExpression: currentRegularExpression, stringLength: "Full");
            
            //  This deals with the special case of if nothing is selected, just print the entire table once.
            if (procedureSelection == ".*" && contrastSelection == ".*" && dyeSelection == ".*" && currentRegularExpression == "")
            {
                hashtags = test.hashtags(currentRegularExpression: currentRegularExpression, stringLength: "One");
            }

            for index2 in hashtags
            {
                //  Only add to the results counter if
                //  a result was found at that index
                if (index2 != "")
                {
                    print(index)
                    resultsCounter = resultsCounter + 1
                }
            }
        }
        
        /*for index in shortData
        {
            //  This gets the exact text, not a regular expression! Doesn't recognize characters like *, +, . !
            //if((index.range(of: currentRegularExpression, options: .caseInsensitive)) != nil)
            //if((index.range(of: regex, options: .caseInsensitive)) != nil)
            if((index.range(of: currentRegularExpression, options: .caseInsensitive)) != nil)
            {
                //shortData.append(index)
                print(index)
                resultsCounter = resultsCounter + 1
            }
        }*/
        
        //  Concatinating strings in Swift more
        //  difficult than in Java, can't append and int
        //  to a string, need to cast first
        string2 = String(resultsCounter)
        numberOfResultsLabel.text = string1 + string2
        
        print()
        print("End of one search.")
        print()
        print()

          
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




