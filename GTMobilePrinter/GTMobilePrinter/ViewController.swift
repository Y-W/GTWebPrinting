//
//  ViewController.swift
//  GTMobilePrinter
//
//  Created by Yiqi Chen on 9/20/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate, NSURLConnectionDataDelegate {
                            
    let SELECT_PRINTER_ALERT = 1
    let PUT_USR_ALERT = 2
    
    let serverhost = "192.168.1.120"
    let path = "/printfile.php"
    var file: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPrintAlert(file: NSURL) {
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
        
        var fileData = NSData(contentsOfURL: file)
        var parameters = NSString(format: "ptr=%@&usr=%@", printer, usr)
        var requestBody = NSMutableData()
        requestBody.appendData(parameters.dataUsingEncoding(NSASCIIStringEncoding))
//        requestBody.appendData(fileData)
        
        println(fileData.length)
//        println(NSString(data: fileData, encoding: NSUTF8StringEncoding))
        
        var url = "http://".stringByAppendingString(serverhost)
            .stringByAppendingString(path)
//            .stringByAppendingString("?ptr=").stringByAppendingString(printer)
//            .stringByAppendingString("&usr=").stringByAppendingString(usr)
        
        var postRequest = NSMutableURLRequest(URL: NSURL(string: url))
//        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        postRequest.setValue(requestBody.length, forKey: "Content-Length")
//        postRequest.setValue(printer, forKey: "ptr")
//        postRequest.setValue(usr, forKey: "usr")
        postRequest.HTTPMethod = "POST"
        postRequest.HTTPBody = requestBody
        
        var conn = NSURLConnection.connectionWithRequest(postRequest, delegate: self)
        if conn != nil {
            println("Request Successful")
        }
        else {
            println("Request Failed")
        }
        
//        println(fileData.length)
//        println(usr)
//        println(printer)
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
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
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }

}

