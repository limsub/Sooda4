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
    
    
    private let baseURL = URL(string: APIKey.baseURL +  "/ws-channel-238")
    
    
    override init() {
        super.init()
        
        self.manager = SocketManager(socketURL: baseURL!, config: [
            .log(true),
            .compress
            // 헤더가 필요 없나봄
//            .extraHeaders([
//                "Content-Type": "application/json",
//                "Authorization": KeychainStorage.shared.accessToken ?? "" ,
//                "SesacKey": APIKey.key
//            ])
        ])
        
        socket = self.manager.socket(forNamespace: "/ws-channel-238")
        
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED : ", data, ack)
            
//            if let array = data as? [Any],
//               array.count == 2,
//               let secondElement = array[1] as? [String: Any],
//               let sid = secondElement["sid"] as? String {
//                print("세션 아이디: \(sid)")
//                
//                self.socket.emit("channel", sid)
//            } else {
//                print("올바르지 않은 데이터 형식입니다.")
//            }
//            
//            
//            
//            
//            
//            let data = [
//                "Content-Type": "application/json",
//                "Authorization": KeychainStorage.shared.accessToken ?? "" ,
//                "SesacKey": APIKey.key
//            ] as [String: Any]
//            
//            self.socket.emit("channel", data)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED : ", data, ack)
        }
        
        socket.on("channel") { data, ack in
            print("CHANNEL RECEIVED", data, ack)
        }
        
        socket.onAny { event in
            print("-----------------------  onAny Event", event)
        }
    }
    
    func listenConnect(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        self.socket.on(clientEvent: .connect, callback: completion)
    }
    
    func listenDisconnect(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        self.socket.on(clientEvent: .disconnect, callback: completion)
    }
    
    func receivedChatInfo(completion: @escaping ([Any], SocketAckEmitter) -> Void) {
        self.socket.on("channel", callback: completion)
    }
    
    func establishConnection() {
        print("소켓연결")
        socket.connect()
    }

    func closeConnection() {
        print("소켓연결끊음")
        socket.disconnect()
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
