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


class ViewController: UIViewController {
    
    @IBOutlet var navView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var CPTCodeLabel: UILabel!

    //let backgroundImageView = UIImageView()
    

    @IBOutlet weak var regularExpressionSearch: UISearchBar!
    var currentRegularExpression = String("")

    
    //  I added a button -Lindsey
    @IBAction func searchButton(_ sender: UIButton)
    {
        //  Gets ready to set the regular expression equal to the search bar text
        currentRegularExpression = regularExpressionSearch.text ?? "error"
        
        //  Checks this string to see if the regular expression is contained in it or not. This string will become the entire CptLongDescriptions column of medical procdures.
        let text = "HiHelloHi"
        //  Calls the struct (a class-like thing) to create the regular expression
        let hashtags = text.hashtags(currentRegularExpression: currentRegularExpression);
        print("Returning results of Christmas Regular Expression:")
        //  If the text is contained in the regular expression, print it. If not, empty string.
        print(hashtags)
    }
    
    
    @IBAction func navButtonTapped(_ sender: Any) {
        navView.isHidden = !navView.isHidden
    }
    
    // This method only runs after the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        if(CPTCodeData.isEmpty == false){
               CPTCodeLabel.text = CPTCodeData[myIndex]
               titleLabel.text = shortData[myIndex]
               descriptionLabel.text = longData[myIndex]
        }
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named:"unnamed.jpg")!)
        
        //  Will create a regular expression of the string "error" if something other than a String is there
        //currentRegularExpression = regularExpressionSearch//.text ?? "error"
        
        //  Testing Christmas Regular Expressions -Lindsey
        //let text = "I made this wonderful pic last #chRistmas... #instagram #nofilter #snow #fun"

        // Output: ["christmas", "instagram", "nofilter", "snow", "fun"]
        
    }
    
}

