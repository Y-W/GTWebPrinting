//
//  ViewController.swift
//  GTMobilePrinter
//
//  Created by Yiqi Chen on 9/20/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate, NSURLConnectionDataDelegate {
                            
    @IBOutlet var statusField: UITextView
    
    let PRINT_DOCUMENT_ALERT = 1
    let ENTER_USR_ALERT = 2
    
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
        alertView.tag = PRINT_DOCUMENT_ALERT
        self.file = file
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView.show()
    }
    
    func displayUsrAlert() {
        var alertView = UIAlertView(title: "See Print Status",
            message: "Please enter gt username", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Continue")
        alertView.tag = PRINT_DOCUMENT_ALERT
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView.show()
    }
    
    func printDocument(usr: String, printer: String) {
        
        var boundary = "---------------------------14737809831466499882746641449"
        var boundaryData = NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)
        var fileData = NSData(contentsOfURL: file)
        var parameters = NSString(format: "ptr=%@&usr=%@", printer, usr)
        
        var requestBody = NSMutableData()
        requestBody.appendData(boundaryData)
        
        requestBody.appendData("Content-Disposition: form-data; name=\"usr\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        requestBody.appendData(usr.dataUsingEncoding(NSUTF8StringEncoding))
        requestBody.appendData(boundaryData)
        requestBody.appendData("Content-Disposition: form-data; name=\"ptr\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        requestBody.appendData(printer.dataUsingEncoding(NSUTF8StringEncoding))
        requestBody.appendData(boundaryData)
        
        requestBody.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file_from_ios.pdf\"\r\n".dataUsingEncoding(NSUTF8StringEncoding))
        requestBody.appendData("Content-Type: application/pdf\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding))
//        println(NSString(data: requestBody, encoding: NSUTF8StringEncoding))
        requestBody.appendData(fileData)
        requestBody.appendData(boundaryData)
        
//        println(fileData.length)
//        println(NSString(data: fileData, encoding: NSUTF8StringEncoding))
        
        var url = "http://".stringByAppendingString(serverhost)
            .stringByAppendingString(path)
        
        var postRequest = NSMutableURLRequest(URL: NSURL(string: url))
        postRequest.setValue(NSString(format: "multipart/form-data; boundary=%@", boundary), forHTTPHeaderField: "Content-Type")
        postRequest.HTTPMethod = "POST"
        postRequest.HTTPBody = requestBody
        
        var conn = NSURLConnection.connectionWithRequest(postRequest, delegate: self)
        if conn != nil {
            println("Request Successful")
        }
        else {
            println("Request Failed")
        }
        
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        if alertView.tag == PRINT_DOCUMENT_ALERT {
            var usr = alertView.textFieldAtIndex(0).text
            if buttonIndex == 1 {
                printDocument(usr, printer: "Mobile_black")
            }
            if buttonIndex == 2 {
                printDocument(usr, printer: "Mobile_color")
            }
        }
    }
    
//    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
//        if data == nil {
//            return
//        }
//        println(NSString(data: data, encoding: NSUTF8StringEncoding))
//    }

}

