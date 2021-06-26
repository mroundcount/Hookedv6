//
//  AppDelegate.swift
//  Hooked
//
//  Created by Michael Roundcount on 2/28/20.
//  Copyright © 2020 Michael Roundcount. All rights reserved.
//

import UIKit
import CoreData
import Firebase

import FirebaseCore
import FirebaseMessaging

import UserNotifications
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let gcmMessageIDKey = "gcm.message_id"
    /*
    static let isToken: String? = {
        return InstanceID.instanceID().token()
    }()
    */

 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Added for push notificatons
        //Demo video:
        //https://www.youtube.com/watch?v=vvq0etotS8M
        connectToFirebase()
        FirebaseApp.configure()
        //End push notifications
        
        Messaging.messaging().delegate = self
        // Use Firebase library to configure APIs
        
        //If the user has been authenticated we will set the initial view controller accordingly
        configureInitialViewController()
        
        //Facebook Login
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Push Notifications on 6/22/2021... Generic notifications
        // Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            print("Here 1")
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        //End section just for push notifications
        return true
    }
    
    //Push notification 6/22/2021
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        print("Here 4")
        return handled
    }
    
    //Push notification
    //https://firebase.google.com/docs/cloud-messaging/ios/receive
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageId = userInfo[gcmMessageIDKey] {
            print("messageId: \(messageId)")
        }
        print(userInfo)
    }
    
    //Not sure where these next two functions come from.
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    func connectToFirebase() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    /*
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("messageID: \(messageID)")
        }
        connectToFirebase()
        Messaging.messaging().appDidReceiveMessage(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }*/
    
    /*
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = AppDelegate.isToken else {
            return
        }
        print("token: \(token)")
    }
    */
    

    

    //added for login
    //If the user has been authenticated we will set the initial view controller accordingly
    func configureInitialViewController() {
        var initialVC: UIViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //toggle between the view controller depending if the user exists or is logged in
        if Auth.auth().currentUser != nil {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_TABBAR)
        } else {
            initialVC = storyboard.instantiateViewController(withIdentifier: IDENTIFIER_WELCOME)
        }
        //assign this variable root to the window view
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    
    
    /* Get rid of this to use the windows method
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
 */
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Hooked")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    //Not sure what this does... might be default
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//Extension for push notifications 6/22/2021
//https://firebase.google.com/docs/cloud-messaging/ios/receive
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
 
  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("Here 7")
    let userInfo = notification.request.content.userInfo
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // ...
    // Print full message.
    print(userInfo)
    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print("Here 8")
    // ...

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}
 

//Extension for push notifications 6/22/2021
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

        print("Here 9")
        
      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
