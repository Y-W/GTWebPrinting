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
    @IBOutlet var apptitle: UILabel
    
    let PRINT_DOCUMENT_ALERT = 1
    let ENTER_USR_ALERT = 2
    
    let serverhost = "143.215.204.99"
    let postPath = "/printfile.php"
    let getPath = "/getstatus.php"
    
    var username: String?
    var file: NSURL?
    var alertView: UIAlertView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
            appLogo.hidden = true
            apptitle.hidden = true
        }
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
        alertView!.alertViewStyle = UIAlertViewStyle.PlainTextInput
        if username != nil {
            alertView!.textFieldAtIndex(0).text = username
        }
        alertView!.show()
    }
    
    func displayUsrAlert() {
        alertView = UIAlertView(title: "See Print Status",
            message: "Please enter gt username", delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Continue")
        alertView!.tag = ENTER_USR_ALERT
        alertView!.alertViewStyle = UIAlertViewStyle.PlainTextInput
        if username != nil {
            alertView!.textFieldAtIndex(0).text = username
        }
        alertView!.show()
    }
    
    func printDocument(usr: String, printer: String) {
        
        if usr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            return
        }
        username = usr
        
        var paths = file?.absoluteString.componentsSeparatedByString("/")
        var filename = paths![paths!.count - 1]
        if !filename.hasSuffix(".pdf") {
            filename += ".pdf"
        }
        
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
        
        requestBody.appendData(NSString(format: "Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", filename).dataUsingEncoding(NSUTF8StringEncoding))
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
            sleep(2)
            getPrintStatus(usr)
        }
        else {
            println("Request Failed")
        }
    }
    
    func getPrintStatus(usr: String) {
        
        if usr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            return
        }
        username = usr
        
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
            }
            if buttonIndex == 2 {
                printDocument(usr, printer: "Mobile_color")
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

