//
//  PicturePicker.swift
//  Flutterasia
//
//  Created by Imron Rosdiana on 9/19/17.
//  Copyright © 2017 Imron Rosdiana. All rights reserved.
//

import UIKit

let picker = UIImagePickerController()

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc func openGallery() -> Void {
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func openCamera() -> Void {
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.showsCameraControls = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            // Hide add photo label
            self.addPhotoLabel.isHidden = true
            
            // Change image
            changeImage = true
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
