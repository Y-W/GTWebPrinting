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
    @IBOutlet var appLogo: UIImageView
    
    let PRINT_DOCUMENT_ALERT = 1
    let ENTER_USR_ALERT = 2
    
    let serverhost = "192.168.1.120"
    let postPath = "/printfile.php"
    let getPath = "/getstatus.php"
    var file: NSURL?
    var alertView: UIAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        statusField.text = ""
    }
    
    @IBAction func refreshStatus(sender: AnyObject) {
        displayUsrAlert()
    }
    
    func displayPrintAlert(file: NSURL) {
        alertView = UIAlertView(title: "Print Document",
            message: "Please enter gt username", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "GT_Mobile_Black", "GT_Mobile_Color")
        alertView!.tag = PRINT_DOCUMENT_ALERT
        self.file = file
        alertView!.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView!.show()
    }
    
    func displayUsrAlert() {
        alertView = UIAlertView(title: "See Print Status",
            message: "Please enter gt username", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Continue")
        alertView!.tag = ENTER_USR_ALERT
        alertView!.alertViewStyle = UIAlertViewStyle.PlainTextInput;
        alertView!.show()
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
        
        var url = "http://".stringByAppendingString(serverhost)
            .stringByAppendingString(postPath)
        
        var postRequest = NSMutableURLRequest(URL: NSURL(string: url))
        postRequest.setValue(NSString(format: "multipart/form-data; boundary=%@", boundary), forHTTPHeaderField: "Content-Type")
        postRequest.HTTPMethod = "POST"
        postRequest.HTTPBody = requestBody
        
        var conn = NSURLConnection.connectionWithRequest(postRequest, delegate: self)
        if conn != nil {
            println("Request Successful")
            getPrintStatus(usr)
        }
        else {
            println("Request Failed")
        }
    }
    
    func getPrintStatus(usr: String) {
        
        var url = "http://".stringByAppendingString(serverhost)
            .stringByAppendingString(getPath)
            .stringByAppendingString("?usr=")
            .stringByAppendingString(usr)
        
        var statusData = NSData(contentsOfURL: NSURL(string: url))
        statusField.text = NSString(format: "Print Status of %@: \n\n%@", usr, NSString(data: statusData, encoding: NSUTF8StringEncoding))
    }
    
    func alertView(alertView: UIAlertView!, didDismissWithButtonIndex buttonIndex: Int) {
        
        var usr = alertView.textFieldAtIndex(0).text
        if alertView.tag == PRINT_DOCUMENT_ALERT {
            if buttonIndex == 1 {
                printDocument(usr, printer: "Mobile_black")
                println("black")
            }
            if buttonIndex == 2 {
                printDocument(usr, printer: "Mobile_color")
                println("color")
            }
        }
        else {
            if buttonIndex == 1 {
                getPrintStatus(usr)
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

