//
//  SocketIOManager.swift
//  Sooda4
//
//  Created by 임승섭 on 1/24/24.
//

import Foundation
import SocketIO

// 152 / 238 (workspace id / channel id)

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private let baseURL = URL(string: APIKey.baseURL)   // url은 그냥 기본. namespace에서 찾아주기
    
    var isOpen = false          // 소켓 연결 상태를 쉽게 파악하기 위한 변수
    var shouldReconnect = false // 앱이 포그라운드로 진입할 때(sceneDidBecomeActive), 소켓을 재연결해야 하는지 여부 -> sceneDidEnterBackground에서 값 변경
    
    
    
    override init() {
        super.init()
        
        self.manager = SocketManager(socketURL: baseURL!, config: [
//            .log(true),
            .compress
        ])
        
//        socket = self.manager.socket(forNamespace: "/ws-channel-238")
        socket = self.manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED : ", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED : ", data, ack)
        }
        
    }
    
    // 소켓 연결
    func establishConnection(_ router: SocketRouter) {
        self.closeConnection()  // 혹시 연결되어 있는 소켓이 있으면 끊어준다
        print(#function)
        socket = self.manager.socket(forNamespace: router.nameSpace)
        socket.connect()
        self.isOpen = true
        
    }
    
    // 소켓 연결 해제
    func closeConnection() {
        print(#function)
        socket.disconnect()
        socket.removeAllHandlers()
        self.isOpen = false
    }
    
    // 소켓 응답
    func receive<T: Decodable>(
        type: T.Type,
        router: SocketRouter,
        completion: @escaping (T) -> Void
    ) {
        print(#function)
        
        self.socket.on(router.event) { dataArr, ack in
            
            guard let data = dataArr.first,
                  let decodedData: T = try? self.decodeData(data: data) else {
                return
            }
            
            completion(decodedData)
            
//            ack.with("hi")  // 서버에게 응답을 보낸다?
//            ack.with("메세지 수신 완료!")
        }
    }

//    
//    func receiveChannelChatInfo(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
//        print("소켓 응답")
//        self.socket.on("channel", callback: completion)
//    }
//    

    // 소켓 연결 이벤트
    func listenConnect(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        self.socket.on(clientEvent: .connect, callback: completion)
    }
    
    // 소켓 연결 해제 이벤트
    func listenDisconnect(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        self.socket.on(clientEvent: .disconnect, callback: completion)
    }
    
    
    

    
    
//    func establishConnection() {
//        print(#function)
//        
//        socket.on(clientEvent: .connect) { data, ack in
//            print("socket is connected", data, ack)
//        }
////        socket.connect()
//    }
//    
//    func closeConnection() {
//        print(#function)
//        
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("socket is disconnected", data, ack)
//        }
////        socket.disconnect()
//    }
//    
//    func emit(message: [String: Any]) {
//        print("emit message : ", message)
//        socket.emit("hi", with: ["되는거냐 이거?"], completion: nil)
//    }
//    
//    
//    
////    func receive() {
////        print(#function)
////        
////        socket.on("channel") { dataArray, ack in
////            print("channel received", dataArray, ack)
////        }
////    }
//    
//    
//    func sendMessage(message: String, nickname: String) {
//        socket.emit("event",  ["message" : "This is a test message"])
//        
//        socket.emit("event1", [["name" : "ns"], ["email" : "@naver.com"]])
//        
//        socket.emit("event2", ["name" : "ns", "email" : "@naver.com"])
//        
//        socket.emit("msg", ["nick": nickname, "msg" : message])
//        
//    }
//    
}

// 얘 안씀
extension String {
    func decodeUnicodeEscape() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }

        guard let decodedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }

        return decodedString as String
    }
}

extension SocketIOManager {
    private func decodeData<T: Decodable>(data: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: data)
        let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
        
        return decodedData
    }
}
