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


class CourseCreatorViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dayOfWeakPicker: UIPickerView!
    var pickerData: [String] = [String]()
    var dayValue : String?
    var dateTime : Date?
    
    @IBAction func handleTimeUpdated(_ sender: UIDatePicker) {
        dateTime = sender.date
        print(dateTime!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        // Connect data:
        self.dayOfWeakPicker.delegate = self
        self.dayOfWeakPicker.dataSource = self
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
