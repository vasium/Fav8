//
//  StationViewController.swift
//  Fav8
//
//  Created by Administrator on 2018-05-09.
//  Copyright © 2018 Woqomoqo. All rights reserved.
//

import UIKit
import os.log


class StationViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    
    var editStation: Station?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDataFromNotification(_:)), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        urlTextField.delegate = self
        
        // Set up views if editing an existing Station.
        if let station = editStation {
            navigationItem.title = station.name
            nameTextField.text = station.name
            urlTextField.text = station.url
            photoImageView.image = station.photo
        }
        
        // Enable the Save button only if the text field has a valid Station name.
        updateSaveButtonState()
    }
    
    
    // handle notification
    @objc func getDataFromNotification(_ notification: NSNotification) {
        
        let stationName = notification.userInfo!["name"]
        let stationUrl = notification.userInfo!["streamUrl"]
        let stationImg = notification.userInfo!["urlImage"]
        
        nameTextField.text = stationName as? String
        urlTextField.text = stationUrl as? String
        
        if let imageUrlString = stationImg {
            if let imageUrl:URL = URL(string: imageUrlString as! String) {
                if let imageData:NSData = NSData(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData as Data)
                    if photoImageView.image != nil {
                        photoImageView.image = image
                    }
                }
            }
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddStationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddStationMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The StationViewController is not inside a navigation controller.")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let url = urlTextField.text ?? ""
        let photo = photoImageView.image
        
        // Set the station to be passed to StationTableViewController after the unwind segue.
        editStation = Station(name: name, url: url, photo: photo)
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        //        let text = nameTextField.text ?? ""
        //        let text = urlTextField.text ?? ""
        //        saveButton.isEnabled = !text.isEmpty
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
