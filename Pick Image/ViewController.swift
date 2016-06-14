//
//  ViewController.swift
//  Pick Image
//
//  Created by Isaac To on 5/28/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(),
                              NSForegroundColorAttributeName : UIColor.whiteColor(),
                              NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                              NSStrokeWidthAttributeName : NSNumber(double: -3.0)]
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: textAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: textAttributes)

        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        pickImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        if sender == cameraButton {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageDisplay.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}