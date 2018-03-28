//
//  DiveViewController.swift
//  Scuba
//
//  Created by Hubert Ka on 2018-01-06.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit
import os.log

class DiveViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var diveNumberTextField: UITextField!
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private var textFields = [UITextField]()
    
    /*
     This value is either passed by 'DiveTableViewController' in 'prepare(for:sender:)' or constructed as part of adding a new dive.
    */
    var dive: Dive?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textFields += [
            diveNumberTextField,
            activityTextField,
            dateTextField,
            locationTextField
        ]
        
        // Handle the text field's user input through delegate callbacks.
        for index in 0..<textFields.count {
            textFields[index].delegate = self
            textFields[index].tag = index
        }
        
        // Set up views if editing an existing Dive
        if let dive = dive {
            navigationItem.title = "Dive \(dive.diveNumber)"
            diveNumberTextField.text  = dive.diveNumber
            activityTextField.text = dive.activity
            dateTextField.text = dive.date
            locationTextField.text = dive.location
            photoImageView.image = dive.photo
        }
        
        // Enable the Save button only if the text fields have valid entries.
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        if textField == textFields.last {
            textField.resignFirstResponder()
        }
        else {
            let nextField = textField.tag + 1
            textFields[nextField].becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField) {
        case diveNumberTextField:
            navigationItem.title = "Dive \(textField.text ?? "")"
        case activityTextField:
            activityLabel.text = textField.text
        case dateTextField:
            dateLabel.text = textField.text
        case locationTextField:
            locationLabel.text = textField.text
        default:
            fatalError("The text field, \(textField), is not in the textFields array: \(textFields)")
        }
        
        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user cancelled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on the style of presentation (model or push presentation), this view controller needs to be dismissed in two different ways. Segue identifiers are not necessary here because dismissal type of the view controller is only based on the presentation (or animation in) of a view controller (i.e. modal -> dimiss, show -> pop)
        let isPresentingInAddDiveMode = presentingViewController is UINavigationController
        
        if isPresentingInAddDiveMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The DiveViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling.", log: OSLog.default, type: .debug)
            return
        }
        
        let diveNumber = diveNumberTextField.text ?? ""
        let activity = activityTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the dive to be passed to DiveTableViewController after the unwind segue.
        dive = Dive(diveNumber: diveNumber, activity: activity, date: date, location: location, photo: photo)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        for index in 0..<textFields.count {
            textFields[index].resignFirstResponder()
        }
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text fields are empty
        let diveNumberText = diveNumberTextField.text ?? ""
        let activityText = activityTextField.text ?? ""
        let dateText = dateTextField.text ?? ""
        let locationText = locationTextField.text ?? ""
        
        saveButton.isEnabled = !diveNumberText.isEmpty || !activityText.isEmpty || !dateText.isEmpty || !locationText.isEmpty
    }
}

