//
//  ViewController.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/17/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    var courses = [NSManagedObject]()
   //static let myNotification = Notification.Name("myNotification")
    let locationManager = CLLocationManager()

    @IBOutlet weak var coursesList: UITableView!
    
    var done = false
    var message = ""
    var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your list of courses"
        coursesList.delegate = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    class PostForData {
        // the completion closure signature is (String) -> ()
        func forData(origin: String, destination: String, completion: @escaping (String) -> ()) {
            if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=transit&key=AIzaSyCowB88aliJqJuGNEsUjInIXMCKPxA9VJs") {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let postString : String = "uid=59"
                request.httpBody = postString.data(using: String.Encoding.utf8)
                let task = URLSession.shared.dataTask(with: request) {
                    data, response, error in
                    if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) , error == nil {
                        completion(jsonString)
                    } else {
                        print("error=\(error!.localizedDescription)")
                    }
                }
                task.resume()
            }
        }
    }
    
    func parseJSON(data: Data) -> String{
        var times = [String]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            if let routes = json["routes"] as? [[String: AnyObject]] {
                for route in routes {
                    if let legs = route["legs"] as? [[String: AnyObject]] {
                        for leg in legs {
                            if let duration = leg["duration"] as? [String: AnyObject] {
                                if let time = duration["text"] as? String {
                                    times.append(time)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        message =  times[0]
        done = true
        return message
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
    
    func getDuration(origin: String, destination: String) -> String{
        let pfd = PostForData()
        var result = ""
        // you call the method with a trailing closure
        pfd.forData(origin: origin.replacingOccurrences(of: " ", with: "%20"),destination: destination.replacingOccurrences(of: " ", with: "%20")) {
            jsonString in
            result.append(self.parseJSON(data: jsonString.data(using: .utf8)!))
        }
        return result
    }
    
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
        //NotificationCenter.default.post(name: ViewController.myNotification, object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
    }
    
    func tableView(_ tableView:
        UITableView,
                        didSelectRowAt indexPath: IndexPath) {
        let origin = String(locValue.latitude) + " " + String(locValue.longitude)
        var destination = courses[indexPath.item].value(forKey: "address") as! String
        destination.append(" ")
        destination.append(courses[indexPath.item].value(forKey: "zipcode") as! String)
        destination.append(" ")
        destination.append(courses[indexPath.item].value(forKey: "city") as! String )
        destination.append(" ")
        destination.append(courses[indexPath.item].value(forKey: "country") as! String)
        message = getDuration(origin: origin,destination: destination)
        while(done == false){
            print(2)
        }
        print(locValue)
        print(message)
        done = false

        if indexPath.item == 0 {
            let alertController = UIAlertController(title: "Estimated duration", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true) {}
          //  self.dismiss(animated: true, completion: nil)
        }
        
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
                cell.courseTime?.text = "\(hour):0\(minutes) AM"
            }
            if(hour==0){
                cell.courseTime?.text = "12:0\(minutes) AM"
            }
            if(hour>12){
                let tmp = hour-12
                cell.courseTime?.text = "\(tmp):0\(minutes) PM"
            }
            if(hour==12){
                cell.courseTime?.text = "\(hour):0\(minutes) PM"
            }
        }else{
            if(hour<10){
                cell.courseTime?.text = "\(hour):\(minutes) AM"
            }
            if(hour==0){
                cell.courseTime?.text = "12:\(minutes) AM"
            }
            if(hour>12){
                let tmp = hour-12
                cell.courseTime?.text = "\(tmp):\(minutes) PM"
            }
            if(hour==12){
                cell.courseTime?.text = "\(hour):\(minutes) PM"
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

