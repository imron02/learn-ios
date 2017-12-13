//
//  FormProfileTableViewController.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 13/12/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

class FormProfileTableViewController: UITableViewController {

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var zodiacTextField: UITextField!
    @IBOutlet weak var hobbyTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
    }
    
    func createDatePicker() {
        // Change style date picker
        datePicker.datePickerMode = .date
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePicker))
        toolbar.setItems([done], animated: true)
        
        // Event for birthday textField
        birthDayTextField.inputAccessoryView = toolbar
        birthDayTextField.inputView = datePicker
    }
    
    @objc func doneDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthDayTextField.text = dateFormatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
}
