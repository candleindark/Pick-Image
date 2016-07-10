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
    
    @IBOutlet private weak var memeDisplay: UIView!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    let imagePicker = UIImagePickerController()
    
    private var adjustedForKeyboard = false

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
        
        subscribeToKeyboardNotifications()
        
        pickImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        shareButton.enabled = imageDisplay.image != nil
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
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
    
    @IBAction private func shareMeme() {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            activityType, completed, returnedItems, activityError in
            
            if completed {
                self.saveMeme(memedImage)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageDisplay.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber
        
        if isCurrentAppKeyboard.boolValue {
            if bottomTextField.isFirstResponder() {
                if !adjustedForKeyboard {
                    view.frame.origin.y -= getKeyboardHeight(notification)
                    adjustedForKeyboard = true
                }
            } else {
                if adjustedForKeyboard {
                    adjustForKeyboardRemoval(notification)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let isCurrentAppKeyboard = notification.userInfo![UIKeyboardIsLocalUserInfoKey] as! NSNumber
        
        if isCurrentAppKeyboard.boolValue && adjustedForKeyboard {
            adjustForKeyboardRemoval(notification)
        }
    }
    
    func adjustForKeyboardRemoval(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
        adjustedForKeyboard = false
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let keyboardSize = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue    // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    private func generateMemedImage() -> UIImage {
        // Render image
        UIGraphicsBeginImageContext(memeDisplay.frame.size)
        memeDisplay.drawViewHierarchyInRect(CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: memeDisplay.frame.size), afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    private func saveMeme(memedImage: UIImage) {
        let savedMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageDisplay.image!, memedImage: memedImage)
    }
}