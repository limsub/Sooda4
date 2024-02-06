//
//  AppDelegate.swift
//  Sooda4
//
//  Created by 임승섭 on 1/4/24.
//

import UIKit
//import FirebaseCore
import Firebase
import FirebaseAnalytics
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase Anaylitics
        FirebaseApp.configure()
//        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        // Firebase Message
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
            print("Notification Authorization : \(didAllow)")
        }
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()


        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
//            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
          }
        }
        
        
        return true
    }

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

//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("----- device token -----")
//        print(deviceToken)
//        print("------------------------")
//    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(#function)
        print("****** \(deviceToken) ******")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let firebaseToken = fcmToken ?? "No Token"
        print("firebase token : \(firebaseToken)")
        
        
        UserDefaults.standard.set(firebaseToken, forKey: "hi")
        

        
        
//        Messaging.messaging().isAutoInitEnabled = true
    }
    
    
    
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("********\(#function)********")
        completionHandler([.alert, .badge, .sound])
        
        
        if let userInfo = notification.request.content.userInfo as? [String: Any] {
            print("***** \(userInfo) *****")
            
            print(" ++ \(userInfo["workspace_id"])")
            print(" --", type(of: userInfo["workspace_id"]))
            if let workspaceId = userInfo["workspace_id"] as? Int {
                print("int workspaceId : \(workspaceId)")
            } else {
                print("int failed")
            }
            
            if let workspaceId = userInfo["workspace_id"] as? String {
                print("string workspaceId : \(workspaceId)")
            } else {
                print("string failed")
            }
            
            
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: userInfo) else {
                print("1. 디코딩 실패")
                return
            }
            
            
           
            
            do {
//                let decodedData = try JSONDecoder().decode(PushChannelChattingDTO.self, from: jsonData)
                
                let decodedData = try JSONDecoder().decode(PushDMChattingDTO.self, from: jsonData)
                
                print("final : 디코딩 성공")
                print(decodedData)
                
                
            } catch {
                print("2. 디코뎅 에러 : \(error)")
            }
            

        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("********\(#function)********")
        completionHandler()
    }
}
