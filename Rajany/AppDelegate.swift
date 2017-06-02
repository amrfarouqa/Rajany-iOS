 //
//  AppDelegate.swift
//  Rajany
//
//  Created by Amr Farouq on 10/29/16.
//  Copyright © 2016 Amr Farouq. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Firebase
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // [END setup_gidsignin]
        
        FBSDKApplicationDelegate.sharedInstance().application(application,
                                                              didFinishLaunchingWithOptions:launchOptions)
        
        
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let prefs:UserDefaults = UserDefaults.standard
        let isSlideShow:Bool = prefs.bool(forKey: "Status")
        let isUserLoggedIn:Bool = prefs.bool(forKey: "ISLOGGEDIN")
        
        if(isUserLoggedIn){
            
            let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabBarVC") as! HomeVC
            
            window!.rootViewController = protectedPage
            window!.makeKeyAndVisible()
        }else{
            if(isSlideShow){
                let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                window!.rootViewController = loginViewController
                window!.makeKeyAndVisible()
            }else{
                let protectedPage = mainStoryBoard.instantiateViewController(withIdentifier: "SlideShowController") as! ViewController
                window!.rootViewController = protectedPage
                window!.makeKeyAndVisible()
            }
        }
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation) {
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url,
                                                                     // [START old_options]
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // [START_EXCLUDE]
        guard let controller = GIDSignIn.sharedInstance().uiDelegate as? LoginVC else { return }
        // [END_EXCLUDE]
        if let error = error {
            // [START_EXCLUDE]
            controller.showMessagePrompt(message: error.localizedDescription)
            // [END_EXCLUDE]
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        // [END google_credential]
        // [START_EXCLUDE]
        controller.firebaseLogin(credential)
    }

}
