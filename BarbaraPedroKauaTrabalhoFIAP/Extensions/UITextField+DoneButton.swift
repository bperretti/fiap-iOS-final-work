//
//  UITextField+DoneButton.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/01/21.
//

import UIKit

extension UITextField {
    // MARK: - TextField UIToolbar
    func addDoneButtonOnKeyboard(with doneButtonItem: UIBarButtonItem) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320.0, height: 50.0))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        doneToolbar.items = [flexSpace, doneButtonItem]
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}

