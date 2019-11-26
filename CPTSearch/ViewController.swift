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

//  PUT PROTOTYPE CELL CLASS HERE!!
/*class CellClass: UITableViewCell
{
    
}*/
// MARK: - UIViewController

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    var proceduresList = [String]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        /*if(MRIFilterBoolean == true) {
            return filterCount
        }
        if(CTFilterBoolean == true) {
            return filterCount
        }
        else {
        return CPTCodeData.count
        }*/
        
        //proceduresList.removeAll()
        //  Testing with one cell for now.
        //proceduresList.append("Working")
        //proceduresList.append("Working2")
        //return 1
        
        return proceduresList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //use cell format of customized UITableViewCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "theCell", for: indexPath) as! CellClass
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        //cell.textLabel?.text = "Working"
        cell.textLabel?.text = proceduresList[indexPath.row]
        //cell.textLabelTwo?.text = "Working2"
        // Configure the cell...
        /*if (MRIFilterBoolean == true && CTFilterBoolean == false) {
            cell.CPTCodeLabel.text = "CPT Code: \(filterOrder[indexPath.row].CPTCode)"
            cell.CPTShortDescriptionLabel.text = filterOrder[indexPath.row].Short
            return cell
        }
        if(CTFilterBoolean == true && MRIFilterBoolean == false) {
            cell.CPTCodeLabel.text = "CPT Code: \(filterOrder[indexPath.row].CPTCode)"
            cell.CPTShortDescriptionLabel.text = filterOrder[indexPath.row].Short
            return cell
        }
            
        //catalog page displays CPT Code in ascending order
        if alphabeticalBoolean && MRIFilterBoolean == false {
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
         
        }*/
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        orderIndex = indexPath.row
        print(orderIndex)
        
        CPTCodeLabel?.text = CPTCodeData[orderIndex]
        print(CPTCodeData[orderIndex])
        titleLabel?.text = shortData[orderIndex]
        print(shortData[orderIndex])
        descriptionLabel?.text = longData[orderIndex]
        print(longData[orderIndex])
        
        //creates connection to description page
        performSegue(withIdentifier: "searchToDescription", sender: self)
    }
    
    var CPTCodeData = [String]() // stores all CPT codes
    var shortData = [String]() // stores all CPT short descriptions
    var longData = [String]() // stores all CPT long descriptions
    var CPTDictionary = [String: [String]]() // stores key->value(s) pairs

    var orderIndex = 0 // tracks index location of each order
    var indexTrackerforLongdescription = 0 // tracks index location of CPT long description
    var indexTrackerforCPTCode = 0 // tracks index location of CPT code
    var dictionaryIndex = 0 //keeps track of index location of orderList
    var alphabeticalBoolean = true
    

    @IBOutlet weak var theTable: UITableView!
    
    
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
    
    @IBOutlet weak var regularExpressionSearch: UISearchBar!
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
    loadData()
        
    print("Beginning of one search:")
    print()
    
    
    resultsCounter = 0
    //  Gets ready to set the regular expression equal to the search bar text
    currentRegularExpression = regularExpressionSearch.text ?? "error"
    
    currentRegularExpression = procedureSelection + currentRegularExpression + contrastSelection + dyeSelection
    //currentRegularExpression = procedureSelection + "([A-Z+] )*" + currentRegularExpression
    //currentRegularExpression = procedureSelection + " " + "[a-z0-9]*" + currentRegularExpressio    var test = ""
         // Checks all of the indexes in the
        //  shortData PList to see if it contains the
        //  regular expression or not.
        var test = ""
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
    func loadData()
    {
        CPTCodeData.removeAll()
        shortData.removeAll()
        proceduresList.removeAll()
        longData.removeAll()
        indexTrackerforLongdescription = 0
        indexTrackerforCPTCode = 0
        dictionaryIndex = 0
            
        // obtains Orders.plist
        let url = Bundle.main.url(forResource:"Orders", withExtension: "plist")!
            
        // extract plist info into arrays
        do
        {
            let data = try Data(contentsOf: url)
            let sections = try PropertyListSerialization.propertyList(from: data, format: nil) as! [[Any]]
                
            // loop through each subarray of plist
            // _ defines unnamed parameter, did not need to keep track of index of each subarray
            for (_, section) in sections.enumerated()
            {
                // obtains all components(CPTCode, short description, and long description of a subarray
                for item in section
                {
                    indexTrackerforLongdescription+=1
                    // adds all CPT longDescription to longData
                    if(indexTrackerforLongdescription%3==0)
                    {
                        longData.append(item as! String)
                    }
                    else
                    {
                        // adds all CPTCodes to CPTCodeData
                        if(indexTrackerforCPTCode%2==0)
                        {
                            CPTCodeData.append(item as! String)
                            //proceduresList.append(item as! String)
                        }
                        else
                        {
                            // add all CPT shortDescription to shortData
                            shortData.append(item as! String)
                            //proceduresList.append(item as! String)
                        }
                        indexTrackerforCPTCode+=1
                    }
                }
                // create dictionary: CPTCodeData (key) --> shortData, longData (values)
                //CPTDictionary[CPTCodeData[dictionaryIndex]] = [shortData[dictionaryIndex], longData[dictionaryIndex]]
                //dictionaryIndex+=1
                
            }
        }
        catch
        {
            print("Error grabbing data from properly list: ", error)
        }
        
        for i in 1 ..< shortData.count
        {
            proceduresList.append(CPTCodeData[i] + shortData[i])
        }
        //  Split procedures list into two lists, then go through with a for-loop and combine them into one list and
        //  display that on table.
    }

        

            
        func numberOfSections(in tableView: UITableView) -> Int
        {
             // #warning Incomplete implementation, return the number of sections
             return 1
        }

    
    
    
    
    // This method only runs after the view loads
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //
        
        //  Now starting Truc's table stuff but here:
        //theTable.rowHeight = 80.0
        loadData()
        //CPTCodeLabel?.text = CPTCodeData[orderIndex]
        //titleLabel?.text = shortData[orderIndex]
        //descriptionLabel?.text = longData[orderIndex]
        //resultLabel.text = "\(dictionaryIndex) results"
        //  Gets 22 everytime, getting close!
        //sendValue.loadData();
        
        //  Works! 11!
        /*if (CPTCodeData.isEmpty == true)
        {
            sendValue.loadData()
        }*/

                        
         // Do any additional setup after loading the view.
        // displays data according to boolean status
         if(CPTCodeData.isEmpty == false && alphabeticalBoolean == true)
         {
                CPTCodeLabel?.text = CPTCodeData[orderIndex]
                titleLabel?.text = shortData[orderIndex]
                descriptionLabel?.text = longData[orderIndex]
         }
         if(CPTCodeData.isEmpty == false && alphabeticalBoolean == false)
         {
             CPTCodeLabel?.text = sortedDictionary[orderIndex].CPTCode
             titleLabel?.text = sortedDictionary[orderIndex].Short
             descriptionLabel?.text = sortedDictionary[orderIndex].Long
         }
         
         if(MRIFilterBoolean == true || CTFilterBoolean == true) {
             CPTCodeLabel?.text = filterOrder[orderIndex].CPTCode
             titleLabel?.text = filterOrder[orderIndex].Short
             descriptionLabel?.text = filterOrder[orderIndex].Long
         }
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}




