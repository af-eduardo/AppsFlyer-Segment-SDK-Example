//
//  AppDelegate.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import segment_appsflyer_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SEGAppsFlyerTrackerDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
         let config = SEGAnalyticsConfiguration(writeKey: "M6KoxIkiCEJSj6HuKpwbFGRPWi5DdmNN")
        
        config.use(SEGAppsFlyerIntegrationFactory())
        
        config.enableAdvertisingTracking = true       //OPTIONAL
        config.trackApplicationLifecycleEvents = true //OPTIONAL
        config.trackDeepLinks = true                  //OPTIONAL
        config.trackPushNotifications = true          //OPTIONAL
        config.trackAttributionData = true            //OPTIONAL
        config.recordScreenViews = true              //OPTIONAL
        
        SEGAnalytics.setup(with: config)
        
        //identify in Segment & Customer User ID in AF
        SEGAnalytics.shared()?.identify("myTestUserID")
        
        //User Invites
        AppsFlyerTracker.shared()?.appInviteOneLinkID = "JAVu"
        
        SEGAnalytics.debug(true)
        AppsFlyerTracker.shared().isDebug = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//        AppsFlyerTracker.shared().trackAppLaunch()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    /*------------------------------------------------------------------*/
    //deferred deeplink stuff
    func onConversionDataReceived(_ installData: [AnyHashable: Any]) {
        
        guard let first_launch_flag = installData["is_first_launch"] as? Int else {
            return
        }
        
        guard let status = installData["af_status"] as? String else {
            return
        }
        
        if(first_launch_flag == 1) {
            if(status == "Non-organic") {
                if let media_source = installData["media_source"] , let campaign = installData["campaign"]{
                    print("This is a Non-Organic install. Media source: \(media_source) Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
        } else {
            print("Not First Launch")
        }
    }
    
    func onConversionDataRequestFailure(_ error: Error!) {
        //do stuff if it fails
        if let err = error{
            print(err)
        }
    }
    
    func onAppOpenAttribution(_ attributionData: [AnyHashable : Any]!) {
        NSLog("FESS :: onAppOpenAttribution is called")
        print("FESS :: onAppOpenAttribution is called")
        if let data = attributionData{
            NSLog("%@",data)
            print("\(data)")
        }
    }
    
    func onAppOpenAttributionFailure(_ error: Error!) {
        NSLog("FESS :: onAppOpenAttributionFailure is called")
        print("FESS :: onAppOpenAttributionFailure is called")
        //return error from deep link
        if let err = error{
            print(err)
        }
    }
    
    
    //For Swift 4.2 and above reports app open from a Universal Link for iOS 9 or later
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        SEGAnalytics.shared()?.continue(userActivity)
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: nil)
        return true
    }
    
    // Reports app open from deep link for iOS 10 or later
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        return true
    }
    

}

