//
//  Course.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/17/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit

class Course: NSObject {

    // MARK: Properties
    
    var name: String
    var date: [NSDate]?
    var notification: Bool
    var alarm: Bool
    
    init?(name: String, date: [NSDate], notification: Bool, alarm: Bool) {
        self.name = name
        self.date = date
        self.notification = notification
        self.alarm = alarm
        if self.name.isEmpty {
           return nil
        }
    }
    
    // MARK: Types
    /*
    struct PropertyKey {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }*/
}
