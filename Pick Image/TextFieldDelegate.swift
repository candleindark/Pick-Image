//
//  TextFieldDelegate.swift
//  Pick Image
//
//  Created by Isaac To on 6/12/16.
//  Copyright © 2016 Isaac To. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}