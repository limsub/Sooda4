//
//  AppDelegate.swift
//  Sooda4
//
//  Created by 임승섭 on 1/4/24.
//

import UIKit
import FirebaseCore
import FirebaseAnalytics
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase Anaylitics
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
        
        // Firebase Message
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
            print("Notification Authorization : \(didAllow)")
        }
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()

//        print(Date().toString(of: .toAPI))
        
        
//        for i in 0...40 {
//            let requestModel = MakeChannelChattingRequestModel(
//                channelName: "오아아아",
//                workSpaceId: 152,
//                content: "--- pagination Test \(i)",
//                files: []
//            )
//            
//            let dto = MakeChannelChattingRequestDTO(requestModel)
//            
//            NetworkManager.shared.requestCompletionMultipart(
//                type: MakeChannelChattingResponseDTO.self,
//                api: .makeChannelChatting(dto)) { response in
//                    print("\(i)")
//                    print(response)
//                }
//        }
        
        
        let dto = DeviceTokenUpdateRequestDTO(
            deviceToken: "hi"
        )
        NetworkManager.shared.requestCompletionEmptyResponse(
            api: .updateDeviceToken(dto)) { response  in
                switch response {
                case .success:
                    print("디바이스 토큰 업데이트 성공")
                case .failure(let networkError):
                    print("디바이스 토큰 업데이트 실패 - \(networkError)")
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
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let firebaseToken = fcmToken ?? "No Token"
        print("firebase token : \(firebaseToken)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
