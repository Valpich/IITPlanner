//
//  ViewController.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/17/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {

    var courses = [NSManagedObject]()
    
    @IBOutlet weak var coursesList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your list of courses"
    }

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        do {
            let results = try managedContext.fetch(fetchRequest)
            courses = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Course")
        do {
            let results = try managedContext.fetch(fetchRequest)
            courses = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        coursesList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CourseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CourseTableViewCell
        let course = courses[indexPath.row]
        let courseName = course.value(forKey: "name") as! String
        let courseAddress = course.value(forKey: "address") as! String
        let courseZipcode = course.value(forKey: "zipcode") as! String
        let courseCity = course.value(forKey: "city") as! String
        let courseCountry = course.value(forKey: "country") as! String
        let courseDay = course.value(forKey: "day") as! String
        let courseTime = course.value(forKey: "time") as! Date
        let courseNotification = course.value(forKey: "notification") as! Bool
        let courseAlarm = course.value(forKey: "alarm") as! Bool
        cell.courseName?.text = courseName
        cell.courseAddress?.text = courseAddress
        cell.courseZipcode?.text = courseZipcode
        cell.courseCity?.text = courseCity
        cell.courseCountry?.text = courseCountry
        cell.courseDay?.text = courseDay
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: courseTime)
        let minutes = calendar.component(.minute, from: courseTime)
        if(minutes<10){
            if(hour<10){
                cell.courseTime?.text = "0\(hour):0\(minutes)"
            }else{
                cell.courseTime?.text = "\(hour):0\(minutes)"
            }
        }else{
            if(hour<10){
                cell.courseTime?.text = "0\(hour):\(minutes)"
            }else{
                cell.courseTime?.text = "\(hour):\(minutes)"
            }
        }
        if(courseNotification){
            cell.courseNotification?.text = "Notification on"
        }else{
            cell.courseNotification?.text = "Notification off"
        }
        if(courseAlarm){
            cell.courseAlarm?.text = "Alarm on"
        }else{
            cell.courseAlarm?.text = "Alarm off"
        }
        return cell
    }

}

