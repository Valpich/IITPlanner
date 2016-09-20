//
//  CourseTableViewCell.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/20/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseAddress: UILabel!
    @IBOutlet weak var courseZipcode: UILabel!
    @IBOutlet weak var courseCity: UILabel!
    @IBOutlet weak var courseCountry: UILabel!
    @IBOutlet weak var courseDay: UILabel!
    @IBOutlet weak var courseTime: UILabel!
    @IBOutlet weak var courseNotification: UILabel!
    @IBOutlet weak var courseAlarm: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
