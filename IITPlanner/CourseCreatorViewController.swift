//
//  CourseCreatorViewController.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/18/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var dayOfTheWeek: UIPickerView!
    @IBOutlet weak var hour: UIDatePicker!
    @IBOutlet weak var notification: UISwitch!
    @IBOutlet weak var alarm: UISwitch!
    

    @IBAction func validatePressed(_ sender: UIButton) {
        dayValue = dayOfTheWeek.description
        dateTime = hour.date
        isNotification = notification.isOn
        isAlarm = alarm.isOn
        courseName = courseTextField.text
        zipcode = zipcodeTextField.text
        city = cityTextField.text
        country = courseTextField.text
        print(dayValue!)
        print(dateTime!)
        print(isNotification!)
        print(isAlarm!)
        print(courseName!)
        print(zipcode!)
        print(city!)
        print(country!)
    }

    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func endEditingCourseName(_ sender: UITextField) {
        addressTextField.becomeFirstResponder()
    }

    @IBAction func endEditingAddress(_ sender: UITextField) {
        zipcodeTextField.becomeFirstResponder()
    }
    
    @IBAction func endEditingZipcode(_ sender: UITextField) {
        cityTextField.becomeFirstResponder()
    }
    
    @IBAction func endEditingCity(_ sender: UITextField) {
        countryTextField.becomeFirstResponder()
    }

    @IBAction func endEditingCountry(_ sender: UITextField) {
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.dayOfTheWeek.delegate = self
        self.dayOfTheWeek.dataSource = self
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
        print(dayValue!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        /* if textField == self.text1 {
            self.text2.becomeFirstResponder()
        }else if textField == self.text2{
            self.text3.becomeFirstResponder()
        }else{
            self.text1.becomeFirstResponder()
        }*/
        return true
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
