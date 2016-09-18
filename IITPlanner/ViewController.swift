//
//  ViewController.swift
//  IITPlanner
//
//  Created by Valentin Pichavant on 9/17/16.
//  Copyright © 2016 Valentin Pichavant. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    var courses = [String]()
    
    @IBOutlet weak var coursesList: UITableView!
    
    @IBAction func addCourse(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New course",
                                      message: "Add a new course",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.courses.append(textField!.text!)
                                        self.coursesList.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)

        for course in courses{
            print(course)
        }

        present(alert,
                              animated: true,
                              completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your list of courses"
        coursesList.register(UITableViewCell.self,
                                forCellReuseIdentifier: "Cell")    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = coursesList.dequeueReusableCell(withIdentifier: "Cell")
        cell!.textLabel!.text = courses[indexPath.row]
        return cell!
    }

}

