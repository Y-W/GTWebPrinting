//
//  AppDelegate.swift
//  GTMobilePrinter
//
//  Created by Yiqi Chen on 9/20/14.
//  Copyright (c) 2014 Georgia Tech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        var mycontroller = self.window?.rootViewController        
        (mycontroller as ViewController).displayUsrAlert()
        return true
    }
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        var mycontroller = self.window?.rootViewController
        if (mycontroller as ViewController).alertView != nil {
            (mycontroller as ViewController).alertView!.dismissWithClickedButtonIndex(0, animated: false)
        }
        (mycontroller as ViewController).displayPrintAlert(url)
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        var mycontroller = self.window?.rootViewController
//        (mycontroller as ViewController).statusField.text = ""
        exit(0)
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        var mycontroller = self.window?.rootViewController
//        (mycontroller as ViewController).displayUsrAlert()
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

