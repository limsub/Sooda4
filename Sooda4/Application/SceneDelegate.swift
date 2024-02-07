//
//  SceneDelegate.swift
//  Sooda4
//
//  Created by 임승섭 on 1/4/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var appCoordinator: AppCoordinator?
    
    var socketManager = SocketIOManager.shared


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let nav = UINavigationController()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(nav)
        appCoordinator?.start()
//        appCoordinator?.showDirectChannelChattingView(
//            workSpaceId: 152,
//            channelId: 203,
//            channelName: "ababc"
//        )
        
        
        // 노티 등록
        setNotification()
    }
    


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        print(#function)
    }

    // 앱을 백그라운드로 보냈다가 다시 켜는 경우는 여기서 처리해줘야 함. viewDidAppear / viewDidDisappear가 실행되지 않는다.
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        print(#function)
        print("재연결 여부 : ", socketManager.shouldReconnect)
        if socketManager.shouldReconnect {
            // Notification Center로 해당 화면(채팅 화면 - 소켓이 열리는 화면)에 노티 보내기
            // -> 네트워크 콜 하고, 소켓 연결하고 오만가지 함.
            NotificationCenter.default.post(
                name: NSNotification.Name("socketShouldReconnect"),
                object: nil
            )
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        print(#function)
        print("오픈 여부 : ", socketManager.isOpen)
        // 소켓이 연결되어 있는 상태에서 백그라운드로 앱을 보내면,
        // 1. 일단 소켓 끊어주고
        // 2. 다시 포그라운드 진입 시 소켓 연결하도록 한다
        if socketManager.isOpen {
            socketManager.closeConnection()      // 1.
            socketManager.shouldReconnect = true // 2.
        } else {
            socketManager.shouldReconnect = false
        }
    }
}


extension SceneDelegate {
    
    // push notification 클릭해서 AppCoordinator로 접근이 필요한 경우!
}


// private func
extension SceneDelegate {
    
    // push notification을 클릭했다는 notification 받기 위함
    private func setNotification() {
        // 1. 채널 채팅
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(channelChatPushClicked),
            name: Notification.Name("channelChattingPushNotification"),
            object: nil
        )
        
        // 2. 디엠 채팅
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dmChatPushClicked),
            name: Notification.Name("dmChattingPushNotification"),
            object: nil
        )
    }
    
    
    // 1. 채널 채팅
    @objc
    private func channelChatPushClicked(_ notification: Notification) {
        print(#function)
        
//        if let userInfo = notification.userInfo {
//            let channelName =
//        }
    }
    
    
    // 2. 디엠 채팅
    @objc
    private func dmChatPushClicked(_ notification: Notification) {
        print(#function)
    }
    
    
    @objc func a(_ notification: Notification) {
        print("노티받음!!!")
        print("hihihi")
        if let userInfo = notification.userInfo {
            let a = userInfo["a"]
            let b = userInfo["b"]
            
            print("a : \(a) b : \(b)")
        }
    }
}
