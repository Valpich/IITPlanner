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
    var address: String
    var zipcode: String
    var city: String
    var country: String
    var time: Date
    var day: String
    var notification: Bool
    var alarm: Bool
    
    init?(name: String, address: String, zipcode: String, city: String, country: String, time: Date, day: String, notification: Bool, alarm: Bool) {
        self.name = name
        self.address = address
        self.zipcode = zipcode
        self.city = city
        self.country = country
        self.time = time
        self.day = day
        self.notification = notification
        self.alarm = alarm
        if self.name.isEmpty {
           return nil
        }
    }
    
}
