//
//  ViewController.swift
//  GTMobilePrinter
//
//  Created by Yiqi Chen on 9/20/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {
                            
    let SELECT_PRINTER_ALERT = 1
    let PUT_USR_ALERT = 2
    var key: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPrinter(file: NSURL) {
        var alertView = UIAlertView(title: "Print Document",
            message: "Please enter gt username", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "GT_Mobile_Black", "GT_Mobile_Color")
        alertView.tag = SELECT_PRINTER_ALERT
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        objc_setAssociatedObject(alertView, &key, file, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        alertView.show()
    }
    
    func printDocument(file: NSURL, usr: String, printer: String) {
        println(file.absoluteString)
        println(usr)
        println(printer)
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        if alertView.tag == SELECT_PRINTER_ALERT {
            var file = objc_getAssociatedObject(alertView, &key) as NSURL
            var usr = alertView.textFieldAtIndex(0).text
            if buttonIndex == 1 {
                printDocument(file, usr: usr, printer: "Mobile_black")
            }
            if buttonIndex == 2 {
                printDocument(file, usr: usr, printer: "Mobile_color")
            }
        }
    }

}

