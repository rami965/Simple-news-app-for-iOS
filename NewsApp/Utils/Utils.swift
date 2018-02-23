//
//  Utils.swift
//  NewsApp
//
//  Created by MACC on 2/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import UIKit

class Utils: NSObject {
    
    /**
     Show alert with message and ok button.
     
     - parameters:
     - title: The title of the alert window.
     - message: The message body of the alert window.
     - vc: The view controller showing the alert window.
     */
    class func showAlert(title: String, message: String, vc: UIViewController) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            //ok button pressed
            
        }
        
        alertController.addAction(OKAction)
        vc.present(alertController, animated: true, completion:nil)
    }
}
