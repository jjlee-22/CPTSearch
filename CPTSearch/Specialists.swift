//
//  Specialists.swift
//  CPTSearch
//
//  Created by Jonathan on 11/20/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

class Specialists {
    
    //Mark: Properties
    var firstname: String
    var lastname: String
    var department: String
    var email: String
    var phonenumber: String
    
    //MARK: Initilization
    init?(firstname: String, lastname: String, department: String, email: String, phonenumber: String) {
        
        // Initialization should fail if any properties are empty (improved version)
        guard !firstname.isEmpty else {
            return nil
        }
        
        guard !lastname.isEmpty else {
            return nil
        }
        
        guard !department.isEmpty else {
            return nil
        }
        
        guard !email.isEmpty else {
            return nil
        }
        
        guard !phonenumber.isEmpty else {
            return nil
        }
        
        // Initialize stored properties
        self.firstname = firstname
        self.lastname = lastname
        self.department = department
        self.email = email
        self.phonenumber = phonenumber
        
        /*
        // Initialization should fail if any properties are empty
        if firstname.isEmpty || lastname.isEmpty || department.isEmpty || email.isEmpty || phonenumber.isEmpty {
            return nil
        }
         */
    }
}
