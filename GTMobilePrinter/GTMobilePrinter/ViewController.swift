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
    
    let serverhost = "192.168.1.120"
    var file: NSURL?
    
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
        self.file = file
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView.show()
    }
    
    func printDocument(usr: String, printer: String) {
        println(file!.absoluteString)
        println(usr)
        println(printer)
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        println("hello world")
        if alertView.tag == SELECT_PRINTER_ALERT {
            var usr = alertView.textFieldAtIndex(0).text
            if buttonIndex == 1 {
                printDocument(usr, printer: "Mobile_black")
            }
            if buttonIndex == 2 {
                printDocument(usr, printer: "Mobile_color")
            }
        }
    }

}

