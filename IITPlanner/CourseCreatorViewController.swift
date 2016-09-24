//
//  CourseCreatorViewController.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/18/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit
import CoreData

extension Date {
    var localTime: String {
        return description(with: NSLocale.current)
    }
}

class CourseCreatorViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    let pickerData: [String]  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var dayValue : String?
    var dateTime : Date?
    var isNotification : Bool?
    var isAlarm : Bool?
    var courseName : String?
    var address : String?
    var zipcode : String?
    var city : String?
    var country : String?
    var update = false
    
    var courses = [NSManagedObject]()
    var courseUpdate : NSManagedObject?
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var dayOfTheWeek: UIPickerView!
    @IBOutlet weak var hour: UIDatePicker!
    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var alarm: UISwitch!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func validatePressed(_ sender: UIButton) {
        dayValue = pickerData[dayOfTheWeek.selectedRow(inComponent: 0)]
        dateTime = hour.date
        isNotification = notification.isOn
        isAlarm = alarm.isOn
        courseName = courseTextField.text
        zipcode = zipcodeTextField.text
        city = cityTextField.text
        country = countryTextField.text
        address = addressTextField.text
        #if DEBUG
        print(dayValue!)
        print(dateTime!)
        print(isNotification!)
        print(isAlarm!)
        print(courseName!)
        print(zipcode!)
        print(city!)
        print(address!)
        print(country!)
        #endif
        if(true){
            saveCourse(name: courseName!, address: address!, zipcode: zipcode!, city: city!, country: country!, day: dayValue!, time: dateTime!, alarm: isAlarm!, notification: isNotification!)
        }
    }

    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        testFieldEmpty()
        view.endEditing(true)
    }
    
    @IBAction func endEditingCourseName(_ sender: UITextField) {
        testFieldEmpty()
        addressTextField.becomeFirstResponder()
    }

    @IBAction func endEditingAddress(_ sender: UITextField) {
        testFieldEmpty()
        zipcodeTextField.becomeFirstResponder()
    }
    
    @IBAction func endEditingZipcode(_ sender: UITextField) {
        testFieldEmpty()
        cityTextField.becomeFirstResponder()
    }
    
    @IBAction func endEditingCity(_ sender: UITextField) {
        testFieldEmpty()
        countryTextField.becomeFirstResponder()
    }

    @IBAction func endEditingCountry(_ sender: UITextField) {
        testFieldEmpty()
        self.becomeFirstResponder()
    }

    @IBAction func courseValueChanged(_ sender: UITextField) {
        testFieldEmpty()
    }
    
    @IBAction func countryValueChanged(_ sender: UITextField) {
        testFieldEmpty()
    }
    
    @IBAction func zipcodeValueChanged(_ sender: UITextField) {
        if((sender.text?.characters.count)! > 5){
            var zip = ""
            zip = sender.text!
            let cutString = zip.substring(to: zip.index(zip.startIndex, offsetBy: 5))
            sender.text = cutString
        }
        if((sender.text?.characters.count)! == 5){
            cityTextField.becomeFirstResponder()
        }
        testFieldEmpty()
    }
    
    @IBAction func cityValueChanged(_ sender: UITextField) {
        testFieldEmpty()
    }
    
    @IBAction func addressValueChanged(_ sender: UITextField) {
        testFieldEmpty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.dayOfTheWeek.delegate = self
        self.dayOfTheWeek.dataSource = self
        validateButton.isUserInteractionEnabled = false
        if let courseUpdate = courseUpdate {
            courseTextField.text = courseUpdate.value(forKey: "name") as? String
            addressTextField.text = courseUpdate.value(forKey: "address") as? String
            zipcodeTextField.text = courseUpdate.value(forKey: "zipcode") as? String
            cityTextField.text = courseUpdate.value(forKey: "city") as? String
            countryTextField.text = courseUpdate.value(forKey: "country") as? String
            var row = 0
            for i in 0...pickerData.count-1 {
                if (pickerData[i] == courseUpdate.value(forKey: "day") as! String){
                    row = i
                }
            }
            dayOfTheWeek.selectRow(row, inComponent: 0, animated: false)
            hour.date = courseUpdate.value(forKey: "time") as! Date
            notification.isOn = courseUpdate.value(forKey: "notification") as! Bool
            alarm.isOn = courseUpdate.value(forKey: "alarm") as! Bool
            update = true
        }
        testFieldEmpty()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        dayValue = pickerData[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        return true
    }
    
    func testFieldEmpty() {
        if((addressTextField.text?.isEmpty == false) && (zipcodeTextField.text?.isEmpty == false) && (cityTextField.text?.isEmpty == false) && (countryTextField.text?.isEmpty == false) && (courseTextField.text?.isEmpty == false)){
            validateButton.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Persistance
    
    func saveCourse(name: String, address: String, zipcode: String, city: String, country: String?, day: String, time: Date, alarm: Bool, notification: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "Course", in:managedContext)
        if( update == false){
            let course = NSManagedObject(entity: entity!, insertInto: managedContext)
            course.setValue(name, forKey: "name")
            course.setValue(address, forKey: "address")
            course.setValue(zipcode, forKey: "zipcode")
            course.setValue(city, forKey: "city")
            course.setValue(country, forKey: "country")
            course.setValue(day, forKey: "day")
            course.setValue(time, forKey: "time")
            course.setValue(alarm, forKey: "alarm")
            course.setValue(notification, forKey: "notification")
            do {
                try managedContext.save()
                courses.append(course)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }else{
            courseUpdate?.setValue(name, forKey: "name")
            courseUpdate?.setValue(address, forKey: "address")
            courseUpdate?.setValue(zipcode, forKey: "zipcode")
            courseUpdate?.setValue(city, forKey: "city")
            courseUpdate?.setValue(country, forKey: "country")
            courseUpdate?.setValue(day, forKey: "day")
            courseUpdate?.setValue(time, forKey: "time")
            courseUpdate?.setValue(alarm, forKey: "alarm")
            courseUpdate?.setValue(notification, forKey: "notification")
            do {
                try managedContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
