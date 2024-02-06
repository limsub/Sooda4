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
        
        FirebaseApp.configure()
        
        // Firebase Message
        
        // 알림 허용 확인
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
            print("Notification Authorization : \(didAllow)")
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
        
        
        // APNs와 함께 앱을 등록하고 전역적으로 고유한 기기 토큰을 받아야 한다
        // 애플이 제공한 API를 사용해서 앱이 launch될 때마다 앱을 등록하고 기기 토큰을 받는다
        // registerForRemoteNotifications() 메서드를 호출하고, 등록이 성공적이면 didRegisterForRemoteNotificationsWithDeviceToken 메서드에서 토큰 받는다.
        application.registerForRemoteNotifications()


        
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
////            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }
        
        
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
    
    
    
    
    
    
    // 포그라운드에서 알림 받기
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("********\(#function)********")
        

        guard let userInfo = notification.request.content.userInfo as? [String: Any],
              let jsonData = try? JSONSerialization.data(withJSONObject: userInfo)
        else { return }
        
        // push 알림이 오지 말아야 하는 경우
        // - 현재 접속한 채팅방의 톡 알림
        
        
        // 1. 채널 채팅인 경우
        if let channelChatInfo: PushChannelChattingDTO = self.decodingData(data: jsonData) {
            print("1. 채널 채팅 푸시 알림 디코딩 성공!")
            
            // 현재 보고 있는 채팅방인지 확인
            if !self.checkCurrentChannel(chatInfo: channelChatInfo) {
                completionHandler([.list, .badge, .sound, .banner])
            }
        }
        
        
        // 2. 디엠 채팅인 경우
        if let dmChatInfo: PushDMChattingDTO = self.decodingData(data: jsonData) {
            print("1. 디엠 채팅 푸시 알림 디코딩 성공!")
            
            // 현재 보고 있는 채팅방인지 확인
            if !self.checkCurrentDMRoom(chatInfo: dmChatInfo) {
                completionHandler([.list, .badge, .sound, .banner])
            }
        }
    }
    
    
    // 푸시 알림 클릭
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("********\(#function)********")
        
        // 푸시 알림 클릭 시.
        // - 해당하는 채팅방 화면으로 이동
        
        completionHandler()
    }
}


// private func
extension AppDelegate {
    // 채널 or 디엠 채팅 디코딩
    private func decodingData<T: Decodable>(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    /* ===== will Present ===== */
    // 현재 보고 있는 채널 채팅방인지 확인
    private func checkCurrentChannel(chatInfo: PushChannelChattingDTO) -> Bool {
        
        let currentChannelID = UserDefaultsManager.currentChannelID
        let pushChannelID = chatInfo.channel_id
        
        print("2. 현재 보고 있는 채팅방인지 확인! (channelID) : \(currentChannelID) vs. \(pushChannelID)")
        if "\(currentChannelID)" == pushChannelID {
            print("3. 현재 보고 있는 채팅방이기 때문에 푸시 x")
            return true
        } else {
            print("3. 현재 보고 있는 채팅방이 아니기 때문에 푸시 o")
            return false
        }
    }
    
    // 현재 보고 있는 디엠 채팅방인지 확인
    private func checkCurrentDMRoom(chatInfo: PushDMChattingDTO) -> Bool {
        
        let currentOpponentID = UserDefaultsManager.currentDMOpponentID
        let pushDMOpponentID = chatInfo.opponent_id
        
        print("2. 현재 보고 있는 채팅방인지 확인! (opponent id) : \(currentOpponentID) vs. \(pushDMOpponentID)")
        if "\(currentOpponentID)" == pushDMOpponentID {
            print("3. 현재 보고 있는 채팅방이기 때문에 푸시 x")
            return true
        } else {
            print("3. 현재 보고 있는 채팅방이 아니기 때문에 푸시 o")
            return false
        }
    }
}
