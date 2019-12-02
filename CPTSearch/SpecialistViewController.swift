//
//  SpecialistViewController.swift
//  CPTSearch
//
//  Created by Jonathan on 11/12/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

class SpecialistViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var specialistNameLabel: UILabel!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var firstname: String? = ""
    var lastname: String? = ""
    var department: String? = ""
    var email: String? = ""
    var phone: String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field's user input through delegate callbacks
        searchTextField.delegate = self
        lastnameTextField.delegate = self
        departmentTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        firstname = textField.text
        lastname = textField.text
        department = textField.text
        email = textField.text
        phone = textField.text
    }
    
    //MARK: Actions
    
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        specialistNameLabel.text = "Search Specialist"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
