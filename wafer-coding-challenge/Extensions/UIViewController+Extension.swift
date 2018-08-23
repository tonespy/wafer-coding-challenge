//
//  UIViewController+Extension.swift
//  wafer-coding-challenge
//
//  Created by Abubakar Oladeji on 23/08/2018.
//  Copyright © 2018 Tonespy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(_ title : String!, body : String!, showCancel : Bool = false, completion: (() -> Swift.Void)? = nil) {
        let alertController = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            completion?()
        }))
        
        if showCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in}))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
