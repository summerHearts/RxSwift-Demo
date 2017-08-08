//
//  TodoListViewAlert.swift
//  RxSwift-Demo
//
//  Created by Kenvin on 2017/4/17./17.
//  Copyright © 2017年 Kenvin. All rights reserved.
//

import UIKit


extension UIViewController {
    typealias AlertCallback =  ((UIAlertAction) -> Void)
    
    func flash(title: String, message: String, callback: AlertCallback? = nil) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: callback)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
