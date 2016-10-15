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
    
    var message = ""
    var departureTime = ""
    var arrivalTime = ""
    
    var messageArrivalBased = ""
    var departureTimeArrivalBased = ""
    var arrivalTimeArrivalBased = ""
    
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
        }
        navigationItem.leftBarButtonItem = editButtonItem
        
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
        func forDataArrivalBased(arrivalTime: String, origin: String, destination: String, completion: @escaping (String) -> ()) {
            if let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&arrival_time=\(arrivalTime)&mode=transit&key=AIzaSyCowB88aliJqJuGNEsUjInIXMCKPxA9VJs") {
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
    
    override func shouldPerformSegue(withIdentifier: String?, sender: Any?) -> Bool {
        if let ident = withIdentifier {
            if ident == "ShowDetail" {
                if(navigationItem.leftBarButtonItem?.title == "Edit"){
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowDetail" {
            let courseCreatorViewController = segue.destination as! CourseCreatorViewController
            // Get the cell that generated this segue.
            if let selectedCourseCell = sender as? CourseTableViewCell {
                let indexPath = coursesList.indexPath(for: selectedCourseCell)!
                let selectedCourse = courses[indexPath.row]
                courseCreatorViewController.courseUpdate = selectedCourse
            }
        }
        else if segue.identifier == "AddCourse" {
            print("Adding new course.")
        }
    }
    
    func parseJSON(data: Data) -> String{
        var times = [String](arrayLiteral: "","","")
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            if let routes = json["routes"] as? [[String: AnyObject]] {
                for route in routes {
                    if let legs = route["legs"] as? [[String: AnyObject]] {
                        for leg in legs {
                            if let duration = leg["duration"] as? [String: AnyObject] {
                                if let time = duration["text"] as? String {
                                    times[0] = time
                                }
                            }
                            if let departureTime = leg["departure_time"] as? [String: AnyObject] {
                                if let departure = departureTime["text"] as? String {
                                    times[1] = departure
                                }
                            }
                            if let arrivalTime = leg["arrival_time"] as? [String: AnyObject] {
                                if let arrival = arrivalTime["text"] as? String {
                                    times[2] = arrival
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
        departureTime =  times[1]
        arrivalTime =  times[2]
        return message
    }
    
    func parseJSONArrivalBased(data: Data) -> String{
        var times = [String](arrayLiteral: "","","")
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            if let routes = json["routes"] as? [[String: AnyObject]] {
                for route in routes {
                    if let legs = route["legs"] as? [[String: AnyObject]] {
                        for leg in legs {
                            if let duration = leg["duration"] as? [String: AnyObject] {
                                if let time = duration["text"] as? String {
                                    times[0] = time
                                }
                            }
                            if let departureTime = leg["departure_time"] as? [String: AnyObject] {
                                if let departure = departureTime["text"] as? String {
                                    times[1] = departure
                                }
                            }
                            if let arrivalTime = leg["arrival_time"] as? [String: AnyObject] {
                                if let arrival = arrivalTime["text"] as? String {
                                    times[2] = arrival
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        messageArrivalBased =  times[0]
        departureTimeArrivalBased =  times[1]
        arrivalTimeArrivalBased =  times[2]
        return messageArrivalBased
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
        if(navigationItem.leftBarButtonItem?.title == "Edit"){
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
            let time = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: time){
                let origin = String(self.locValue.latitude) + " " + String(self.locValue.longitude)
                var destination = self.courses[indexPath.item].value(forKey: "address") as! String
                destination.append(" ")
                destination.append(self.courses[indexPath.item].value(forKey: "zipcode") as! String)
                destination.append(" ")
                destination.append(self.courses[indexPath.item].value(forKey: "city") as! String )
                destination.append(" ")
                destination.append(self.courses[indexPath.item].value(forKey: "country") as! String)
                let time = self.courses[indexPath.item].value(forKey: "time") as! Date
                let day = self.courses[indexPath.item].value(forKey: "day") as! String
                let timeInterval = self.getNextTime(day: day, time: time)
                self.message = self.getDuration(origin: origin, destination: destination)
                //One is the number of seconds to delay
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when){
                    var msg: String
                    if(self.message != ""){
                        msg = " NEXT DEPATURE" + "\r\n" + "Duration: " + self.message + "\r\n" + "Departure time: " + self.departureTime + "\r\n" + "Arrival time: " + self.arrivalTime
                    }else{
                        msg = "Unable to get data" + "\r\n" + "Feel free to retry"
                    }
                    let alertController = UIAlertController(title: "Estimated duration", message: msg, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true) {}
                    //  self.dismiss(animated: true, completion: nil)
                }
            }
            if CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingLocation()
            }
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
    
    // Support editing the table view.
    func tableView (_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            managedContext.delete(courses[indexPath.row] as NSManagedObject)
            courses.remove(at: indexPath.row)
            do {
                try managedContext.save()
                coursesList.deleteRows(at: [indexPath as IndexPath], with: .fade)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func getDayOfWeek(today:String) -> Int?{
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: todayDate)
            return weekDay
        } else {
            return nil
        }
    }
    
    func dayOfTheWeekToInt(dayOfTheWeek:String)-> Int{
        switch dayOfTheWeek {
        case "Sunday":
            return 1;
        case "Monday":
            return 2;
        case "Tuesday":
            return 3;
        case "Wednesday":
            return 4;
        case "Thursday":
            return 5;
        case "Friday":
            return 6;
        case "Saturday":
            return 7;
        default:
            return 0;
        }
    }
    
    func getNextTime(day:String, time:Date) -> TimeInterval?
    {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        
        print(year)
        print(month)
        print(day)
        print(date.timeIntervalSince1970)
        let weekday = self.getDayOfWeek(today: "\(year)-\(month)-\(currentDay)")
        print(weekday) // 4 = Wednesday
        print(self.dayOfTheWeekToInt(dayOfTheWeek: day))
        return nil
    }
}

