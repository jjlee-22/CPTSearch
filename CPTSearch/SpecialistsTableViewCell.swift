//
//  SpecialistsTableViewCell.swift
//  CPTSearch
//
//  Created by Jonathan on 11/25/19.
//  Copyright © 2019 Cleveland Clinic. All rights reserved.
//

import UIKit

class SpecialistsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var last: UILabel!
    @IBOutlet weak var depart: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
