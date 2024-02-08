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


import RxKakaoSDKCommon



@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
//        application.delegate = self
        
        Messaging.messaging().delegate = self
        
        
        // 알림 허용 확인
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge, .providesAppNotificationSettings]) { didAllow, error  in
            print("Notification Authorization : \(didAllow)")
        }
        

        
        // APNs와 함께 앱을 등록하고 전역적으로 고유한 기기 토큰을 받아야 한다
        // 애플이 제공한 API를 사용해서 앱이 launch될 때마다 앱을 등록하고 기기 토큰을 받는다
        // registerForRemoteNotifications() 메서드를 호출하고, 등록이 성공적이면 didRegisterForRemoteNotificationsWithDeviceToken 메서드에서 토큰 받는다.
//        application.unregisterForRemoteNotifications()
//        print(application.isRegisteredForRemoteNotifications)
        application.registerForRemoteNotifications()
        print(application.isRegisteredForRemoteNotifications)
        // 둘 다 true 출력....?
        
        
        
        


        
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
////            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
//          }
//        }
        
        
        UserDefaultsManager.currentChannelID = -1
        UserDefaultsManager.currentDMOpponentID = -1
        

        
        // 카카오 로그인
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        RxKakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        
        
        

        
        /* pagination test */
        for i in 0...99 {
            let dto = MakeChannelChattingRequestDTO(
                channelName: "오아아아qq",
                workSpaceId: 152,
                content: "test - \(i)",
                files: []
            )
            
            NetworkManager.shared.requestCompletionMultipart(
                type: MakeChannelChattingResponseDTO.self,
                api: .makeChannelChatting(dto)) { response in
                    print(response)
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
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(#function)
        print(error)
    }
    
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let firebaseToken = fcmToken ?? "No Token"
        print("firebase token : \(firebaseToken)")
        
        // 2/7 09:08
        // token : d9QeOO5pskQKgSBCB4RQxz:APA91bFclvzOnbxo-rWMhDoPPgu9-i5Q0W_XqM514FhSBmAJfwN4tZ_rVOYmFVMMfSRwDYM96Bp0zgwNTZz9S62TE6uYCNf3a_RwhTg1tU4Ve5j6mLsqD-_AedqmQueYTVCFVuDDIeGb
        
        print(Messaging.messaging().apnsToken)  // nil 출력..
        
        
        UserDefaults.standard.set(firebaseToken, forKey: "hi")
        
        
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//        NotificationCenter.default.post(
//          name: Notification.Name("FCMToken"),
//          object: nil,
//          userInfo: dataDict
//        )

        
        
//        Messaging.messaging().isAutoInitEnabled = true
    }
    
    
    
    
    
    
    // 포그라운드에서 알림 받기
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("********\(#function)********")
        

        guard let userInfo = notification.request.content.userInfo as? [String: Any] else { return }
        
        // push 알림이 오지 말아야 하는 경우
        // - 현재 접속한 채팅방의 톡 알림
        
        
        // 1. 채널 채팅인 경우
        if let channelChatInfo: PushChannelChattingDTO = self.decodingData(userInfo: userInfo) {
            print("1. 채널 채팅 푸시 알림 디코딩 성공!")
            
            // 현재 보고 있는 채팅방인지 확인
            if !self.checkCurrentChannel(chatInfo: channelChatInfo) {
                completionHandler([.list, .badge, .sound, .banner])
            }
        }
        
        
        // 2. 디엠 채팅인 경우
        if let dmChatInfo: PushDMChattingDTO = self.decodingData(userInfo: userInfo) {
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
        
        
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else { return }
        
        print("푸시 클릭!")
        
        // 1. 채널 채팅인 경우
        if let channelChatInfo: PushChannelChattingDTO = self.decodingData(userInfo: userInfo) {
            print("1. 채널 채팅 푸시 알림 디코딩 성공!")
            // 채널 아이디랑 워크스페이스 아이디 넘겨줌
            // (채널 이름을 어떻게 해야하지...하)
            
            if let channelId = Int(channelChatInfo.channel_id),
               let workspaceId = Int(channelChatInfo.workspace_id) {
                
                let userInfo: [String: Any] = [
                    "channelId": channelId,
                    "workspaceId": workspaceId
                ]

                NotificationCenter.default.post(
                    name: Notification.Name("channelChattingPushNotification"),
                    object: nil,
                    userInfo: userInfo
                )
                
            }
        }
        
        
        // 2. 디엠 채팅인 경우
        if let dmChatInfo: PushDMChattingDTO = self.decodingData(userInfo: userInfo) {
            print("1. 디엠 채팅 푸시 알림 디코딩 성공!")
            // 상대방 유저 아이디랑 워크스페이스 아이디 넘겨줌
            
            let userInfo: [String: Any] = [
                "opponentId": dmChatInfo.opponent_id,
                "workspaceId": dmChatInfo.workspace_id
            ]
            
            NotificationCenter.default.post(
                name: Notification.Name("dmChattingPushNotification"),
                object: nil,
                userInfo: userInfo
            )
        }
        
        
        
        
//        print(jsonData)
        
        // 푸시 알림 클릭 시.
        // - 해당하는 채팅방 화면으로 이동
        
        // 1. 채널 채팅인 경우
        
        
        completionHandler()
    }
}





// private func
extension AppDelegate {
    // 채널 or 디엠 채팅 디코딩
    private func decodingData<T: Decodable>(userInfo: [String: Any]) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: userInfo),
           let decodedData = try? JSONDecoder().decode(T.self, from: jsonData) {
            return decodedData
        }
        
        return nil
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
