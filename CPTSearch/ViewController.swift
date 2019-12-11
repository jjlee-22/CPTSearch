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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,  UITextFieldDelegate
{
    
    
    //  MARK: - Autocomplete Stuff
    //  New! For autocomplete:
    //  This array lists some commonly-occuring words in the test data that the Cleveland Clinic gave us.
    //  For example, 11 short descriptions have the word "Chest" in them.
    var autoCompletionPossibilities = ["Chest", "Head", "Abd", "Angio", "Spine", "Hrt", "Neck", "Orbit", "Pelvis", "Thorax", "Upper Extremity", "Lower Extremity"]
    //  Uh-oh, many procedures have varying names, like sometimes called "Lower Extremity", sometimes "Lwr Extremity".
    //  The regular expression will only catch one or the other, not both....
    var autoCompleteCharacterCount = 0
    var timer = Timer()
    
    @IBOutlet weak var textField: UITextField!
    

    
    //  A bunch of autocomplete methods below. They are all copied-n-pasted from
    //  https://medium.com/@aestusLabs/inline-autocomplete-textfields-swift-3-tutorial-for-ios-a88395ca2635
    //  and worked on the first try!
      func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { //1
          var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
          subString = formatSubstring(subString: subString)
          
          if subString.count == 0 { // 3 when a user clears the textField
              resetValues()
          } else {
              searchAutocompleteEntriesWIthSubstring(substring: subString) //4
          }
          return true
      }
      func formatSubstring(subString: String) -> String {
          let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
          return formatted
      }
      
      
      
      func resetValues() {
          autoCompleteCharacterCount = 0
          textField.text = ""
      }
    
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
           let userQuery = substring
           let suggestions = getAutocompleteSuggestions(userText: substring) //1
           
           if suggestions.count > 0 {
               timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //2
                   let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions) // 3
                   self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery) //4
                   self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery) //5
               })
           } else {
               timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in //7
                   self.textField.text = substring
               })
               autoCompleteCharacterCount = 0
           }
       }
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities { //2
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    
    //  MARK: - Table Methods
    
        //var proceduresList = [String]()
    var newProceduresList = [String]()
    var nc = [String]()
    var ns = [String]()
    var nl = [String]()
    
    //  The amount of rows in the table should be the amount of rows in the proceduresList(), which only stores
    //  the procedures contained in the regular expression.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return proceduresList.count
    }
    
    //  This loops through each index in the proceduresList() and sets the text of that row in the table
    //  equal to that index in the ArrayList.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = proceduresList[indexPath.row]
        return cell
    }
    
    //  This seems to finally be working. If a user clicks on a certain row on the table, it will send them to the
    //  Description screen that has more info about the procedure in that row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //orderIndex2 = indexPath2.row
        //print(orderIndex2)
        pressedSearchButton = true
        orderIndex = indexPath.row
        
       
        //CPTCodeLabel?.text = CPTCodeData[orderIndex]
        //print(CPTCodeData[orderIndex])
        //titleLabel?.text = shortData[orderIndex]
        //print(shortData[orderIndex])
        //descriptionLabel?.text = longData[orderIndex]
        //print(longData[orderIndex])
        
        //creates connection to description page
        performSegue(withIdentifier: "searchToDescription", sender: self)
    }
    
    //  MARK: - Most of the Global Variables
    
    var CPTCodeData2 = [String]() // stores all CPT codes
    var shortData2 = [String]() // stores all CPT short descriptions
    var longData2 = [String]() // stores all CPT long descriptions
    var CPTDictionary2 = [String: [String]]() // stores key->value(s) pairs

    var orderIndex2 = 0 // tracks index location of each order
    var indexTrackerforLongdescription2 = 0 // tracks index location of CPT long description
    var indexTrackerforCPTCode2 = 0 // tracks index location of CPT code
    var dictionaryIndex2 = 0 //keeps track of index location of orderList
    var alphabeticalBoolean2 = true
    
    //  For Search Screen:
    //var pressedSearchButton = false
    @IBOutlet weak var theTable: UITableView!
    
    
    // reference to UI labels
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var CPTCodeLabel: UILabel!
    
    @IBAction func headFilter(_ sender: Any) {
        headBoolean = true
        UserDefaults.standard.set("head", forKey: "bodyPart")
        //performSegue(withIdentifier: "headSegue", sender: self)
    }
    @IBAction func armFilter(_ sender: Any) {
        armBoolean = true
        UserDefaults.standard.set("arm", forKey: "bodyPart")
        //performSegue(withIdentifier: "armSegue", sender: self)
    }
    @IBAction func handFilter(_ sender: Any) {
        handBoolean = true
        UserDefaults.standard.set("hand", forKey: "bodyPart")
        //performSegue(withIdentifier: "handSegue", sender: self)
    }
    @IBAction func legFilter(_ sender: Any) {
        legBoolean = true
        UserDefaults.standard.set("leg", forKey: "bodyPart")
        //performSegue(withIdentifier: "legSegue", sender: self)
    }
    @IBAction func feetFilter(_ sender: Any) {
        feetBoolean = true
        UserDefaults.standard.set("feet", forKey: "bodyPart")
        //performSegue(withIdentifier: "feetSegue", sender: self)
    }
    @IBAction func feetFilter1(_ sender: Any) {
        feetBoolean = true
        UserDefaults.standard.set("feet", forKey: "bodyPart")
        //performSegue(withIdentifier: "feetSegue", sender: self)
    }
    @IBAction func legFilter2(_ sender: Any) {
        legBoolean = true
        UserDefaults.standard.set("leg", forKey: "bodyPart")
        //performSegue(withIdentifier: "legSegue", sender: self)
    }
    @IBAction func armFilter2(_ sender: Any) {
        armBoolean = true
        UserDefaults.standard.set("arm", forKey: "bodyPart")
        //performSegue(withIdentifier: "armSegue", sender: self)
    }
    @IBAction func handFilter2(_ sender: Any) {
        handBoolean = true
        UserDefaults.standard.set("hand", forKey: "bodyPart")
        //performSegue(withIdentifier: "handSegue", sender: self)
    }
    @IBAction func chestFilter(_ sender: Any) {
        chestBoolean = true
        UserDefaults.standard.set("chest", forKey: "bodyPart")
        //performSegue(withIdentifier: "chestSegue", sender: self)
    }
    
    @IBAction func Catalog(_ sender: Any) {
        headBoolean = false
        legBoolean = false
        armBoolean = false
        handBoolean = false
        feetBoolean = false
        chestBoolean = false
        UserDefaults.standard.set(nil, forKey: "bodyPart")
    }
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var attachnotesicon: UIImageView!
    @IBOutlet weak var attachnotes: UITextField!
    
    @IBAction func talk(_ sender: Any) {
        submit.isHidden = false
        attachnotes.isHidden = false
        attachnotesicon.isHidden = false
    }
    
    var FirstTableArray2 = [String]()
    //var SecondTableArray = [SecondTable]()


    //let backgroundImageView = UIImageView()
    
    //  Replaced with textField !
    //@IBOutlet weak var regularExpressionSearch: UISearchBar!
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
    
    //creates the good for bad for button on the long description page
    //there was no data supplied by the doctors or clinic team so a place holder was added
    @IBOutlet weak var goodBad: UISegmentedControl!
    @IBOutlet weak var goodBadLabel: UILabel!
    
    @IBAction func goodBad(_ sender: Any) {
        switch goodBad.selectedSegmentIndex
        {
        case 0:
            goodBadLabel.text = "human people in the hospital"
        case 1:
            goodBadLabel.text = "aliens"
        default:
            break
        }
    }

    
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
    
    //  MARK: - Method for reg-ex, table
    func searchAndLongDescStuff()
    {
        
        //alphabeticalBoolean = true
        //MRIFilterBoolean = false
        //CTFilterBoolean = false
        //loadData2()
        //loadData()
        if (shortData.isEmpty == true)
        {
            sendValue.loadData()
        }
        print("Beginning of one search:")
        print()
        //  Deletes everything from the table each search.
        //proceduresList = []
        proceduresList.removeAll()
        c.removeAll()
        s.removeAll()
        l.removeAll()
            
        resultsCounter = 0
        //  Gets ready to set the regular expression equal to the search bar text

        currentRegularExpression = textField.text ?? "error"
        
        currentRegularExpression = procedureSelection + currentRegularExpression + contrastSelection + dyeSelection
        //currentRegularExpression = procedureSelection + "([A-Z+] )*" + currentRegularExpression
        //currentRegularExpression = procedureSelection + " " + "[a-z0-9]*" + currentRegularExpressio    var test = ""
             // Checks all of the indexes in the
            //  shortData PList to see if it contains the
            //  regular expression or not.
            var test = ""
        /*
            for index in CPTCodeData2
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
                        //  Adds it to the table
                        //proceduresList.append(index)
                        c.append(index)
                        //s.append(index)
                        //l.append(index)
                        //resultsCounter = resultsCounter + 1
                    }
                }
        }*/
                //for index in shortData2
                
                //  Want more if Truc adds more!
                //for i in 0 ... 117
                for i in 0 ... shortData.count - 1
                {
                    //var index = i
                    //test = index
                    //test = shortData2[i]
                    test = shortData[i]
                    
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
                            //print(index)
                            //print(shortData2[i])
                            //c.append(CPTCodeData2[i])
                            //s.append(shortData2[i])
                            //l.append(longData2[i])
                            print(shortData[i])
                            c.append(CPTCodeData[i])
                            s.append(shortData[i])
                            l.append(longData[i])
                            resultsCounter = resultsCounter + 1
                            //proceduresList.append(c[i]+s[i])
                            //  Adds it to the table
                            //proceduresList.append(index)
                            //c.append(index)
                            /*
                            s.append(index)
                            //l.append(index)
                            //resultsCounter = resultsCounter + 1
                            for index3 in CPTCodeData2
                            {
                                if (index3 == index)
                                {
                                    c.append(index)
                                }
                            }
                            for index3 in longData2
                            {
                                if (index3 == index)
                                {
                                    l.append(index)
                                }
                            }*/
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
        for i in 0 ..< s.count
        {
            proceduresList.append(c[i] + " " + s[i])
        }
        print(proceduresList.count)
            
            //loadData2()
            //  Makes the Table totally work! BUT the long description page is totally broken!
            theTable.reloadData()
            UserDefaults.standard.set(proceduresList, forKey: "theProceduresList")
            UserDefaults.standard.set(c, forKey: "tc")
            UserDefaults.standard.set(s, forKey: "ts")
            UserDefaults.standard.set(l, forKey: "tl")
            print(proceduresList.count)
            print()
            print("End of one search.")
            print()
            print()


        }
      //  I added a button -Lindsey
    //  MARK: - Search Button
    @IBAction func searchButton(_ sender: UIButton)
    {
        //sendValue.pressedSearchButton = true
        pressedSearchButton = true
        searchAndLongDescStuff()
        //  Makes the keyboard go away when the Search Button is pressed:
        textField.resignFirstResponder()
    }
    //  MARK: - loadData2()
    func loadData2()
    {
        //print("Deleted the stuff")
        //  Need here for my screen, but not for Truc's:

        
        //CPTCodeData2.removeAll()
        //shortData2.removeAll()
        proceduresList.removeAll()
        //longData2.removeAll()
        CPTCodeData.removeAll()
        shortData.removeAll()
        longData.removeAll()
        //indexTrackerforLongdescription2 = 0
        //indexTrackerforCPTCode2 = 0
        //dictionaryIndex2 = 0
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
        
        for i in 0 ..< shortData.count
        {
            proceduresList.append(CPTCodeData[i] + shortData[i])
        }
        //  Split procedures list into two lists, then go through with a for-loop and combine them into one list and
        //  display that on table.
    }

        

      //    MARK: - Another table method
        func numberOfSections(in tableView: UITableView) -> Int
        {
             // #warning Incomplete implementation, return the number of sections
             return 1
        }

    
    
    
    //  MARK: - viewDidLoad()
    // This method only runs after the view loads
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //  Now starting Truc's table stuff but here:
        //theTable.rowHeight = 80.0
        //loadData2()
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
        /*if (c.isEmpty == true)
        {
            sendValue.loadData()
        }*/
        
        //  Needs to load the original stuff whenever on the Search screen, a fix?
        //let onSearchScreen = true
        //proceduresList.append("Pls dont work")


        

        // displays data according to boolean status
         //if((CPTCodeData.isEmpty == false && alphabeticalBoolean == true) || onSearchScreen == true)
        if (pressedSearchButton == true)
        {
            print("Loaded right for Search screen")
            //searchAndLongDescStuff()
            newProceduresList = UserDefaults.standard.object(forKey: "theProceduresList") as! [String]
            nc = UserDefaults.standard.object(forKey: "tc") as! [String]
            ns = UserDefaults.standard.object(forKey: "ts") as! [String]
            nl = UserDefaults.standard.object(forKey: "tl") as! [String]
            print(newProceduresList.count)
            print(newProceduresList[orderIndex])
            CPTCodeLabel?.text = c[orderIndex]
            titleLabel?.text = s[orderIndex]
            descriptionLabel?.text = l[orderIndex]
        }
        else if(CPTCodeData.isEmpty == false && alphabeticalBoolean == true && MRIFilterBoolean == false && CTFilterBoolean == false)
         {
            print("Loaded right for Catalog screen")
                CPTCodeLabel?.text = CPTCodeData[orderIndex]
                titleLabel?.text = shortData[orderIndex]
                descriptionLabel?.text = longData[orderIndex]
         }
        
        
         else if(CPTCodeData.isEmpty == false && alphabeticalBoolean == false && MRIFilterBoolean == false && CTFilterBoolean == false)
         {
            print("Loaded sorted")
             CPTCodeLabel?.text = sortedDictionary[orderIndex].CPTCode
             titleLabel?.text = sortedDictionary[orderIndex].Short
             descriptionLabel?.text = sortedDictionary[orderIndex].Long
         }
         
         else if(MRIFilterBoolean == true || CTFilterBoolean == true || headBoolean == true) {
            print("Loaded MRI/CT")
             CPTCodeLabel?.text = filterOrder[orderIndex].CPTCode
             titleLabel?.text = filterOrder[orderIndex].Short
             descriptionLabel?.text = filterOrder[orderIndex].Long
         }
        

        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
}






