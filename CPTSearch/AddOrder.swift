//
//  AddOrder.swift
//  CPTSearch
//
//  Created by Student on 12/4/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

class AddOrder: UIViewController {

    
    
    @IBOutlet weak var CPTCodeTextBox: UITextField!
    
    @IBOutlet weak var CPTShortTextBox: UITextField!
    
    @IBOutlet weak var CPTLongTextBox: UITextField!
    

    
    

    @IBAction func AddOrderButton(_ sender: Any) {
    CPTCodeData.append(CPTCodeTextBox.text!)
        shortData.append(CPTShortTextBox.text!)
        longData.append(CPTLongTextBox.text!)
         CPTDictionary[CPTCodeData[deleteCounter]] = [shortData[deleteCounter], longData[deleteCounter]]
        deleteCounter+=1
    }
}
