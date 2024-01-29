//
//  ChannelChattingSocketRepository.swift
//  Sooda4
//
//  Created by 임승섭 on 1/26/24.
//

import Foundation
import RealmSwift

class SocketChannelChattingRepository: SocketChannelChattingRepositoryProtocol {
    
//    private let realm = try! Realm()
    private let socketManager = SocketIOManager.shared
    private let realmManager = RealmManager()
    // 생성 시점에 키체인에 저장된 user id에 따라 realm 파일이 달라짐
    
    // 연결
    func openSocket(_ channelId: Int) {
        socketManager.establishConnection(
            .channel(channelId: channelId)
        )
    }
    
    // 해제
    func closeSocket() {
        socketManager.closeConnection()
    }
    
    // 응답
    func receiveSocket(_ channelId: Int, completion: @escaping (ChattingInfoModel)-> Void) {
        
        socketManager.receive(
            type: SocketchannelChattingResponseDTO.self,
            router: .channel(channelId: channelId)) { dtoData in
                let responseModel = dtoData.toDomain()
                completion(responseModel)
                
                DispatchQueue.main.async {
                    if dtoData.user.user_id != KeychainStorage.shared._id {
                        self.addDataElement(
                            data: dtoData,
                            workSpaceId: -1 // 아 이거 언제 또 받아오냐
                        )
                    }
                }
            }
    }
}


extension SocketChannelChattingRepository {
    // ChannelChattinDTO 타입으로 채팅 정보를 받을 때, 이 채팅 정보를 디비에 저장하기
    private func addDTOData(dtoData: ChannelChattingDTO, workSpaceId: Int) {
        
        
        realmManager.addChannelChattingData(
            dtoData: dtoData,
            workSpaceId: workSpaceId
        )
        
        /*
        /* 디비에 저장하려고 하는 채팅이 이미 디비에 있는 채팅인지 확인하는 작업 */
        if let _ = realm.objects(ChannelChattingInfoTable.self).filter("chat_id == %@", dtoData.chat_id).first {
            print("디비에 이미 있는 채팅. 걸러")
            return
        }
        
        do {
            try realm.write {
                // 1. 디비에 이미 있는 채널인지 확인, 없는 채널이면 디비에 추가
                if let existChannel = realm.objects(ChannelInfoTable.self).filter("channel_id == %@", dtoData.channel_id).first {
                    // 이미 있는 채널
                    
                } else {
                    // 없는 채널 -> 추가해주기
                    let newChannel = ChannelInfoTable(
                        dtoData,
                        workSpaceId: workSpaceId
                    )
                    realm.add(newChannel)
                }
                
                // 2. 디비에 이미 있는 유저인지 확인, 없는 유저면 디비에 추가
                if let existUser = realm.objects(UserInfoTable.self)
                    .filter("user_id == %@", dtoData.user.user_id).first {
                    // 이미 있는 유저
                    
                } else {
                    // 없는 유저 -> 추가해주기
                    let newUser = UserInfoTable(
                        dtoData.user
                    )
                    realm.add(newUser)
                }
                
                
                // 3. 최종 채팅 정보 저장
                let newChannelChatting = ChannelChattingInfoTable()
                newChannelChatting.chat_id = dtoData.chat_id
                newChannelChatting.content = dtoData.content
                newChannelChatting.createdAt = dtoData.createdAt.toDate(to: .fromAPI)!
                
                var fileList = List<String>()
                fileList.append(objectsIn: dtoData.files)
                newChannelChatting.files = fileList
                
                newChannelChatting.channelInfo = realm.objects(ChannelInfoTable.self).filter("channel_id == %@", dtoData.channel_id).first!
                newChannelChatting.userInfo = realm.objects(UserInfoTable.self)
                    .filter("user_id == %@", dtoData.user.user_id).first!
                
                realm.add(newChannelChatting)
            }
        } catch {
            
        }
        */
        
    }
    
    // 채팅 하나를 디비에 저장 (채팅 전송 후 실행)
    private func addDataElement(data: ChannelChattingDTO, workSpaceId: Int) {
        
        self.addDTOData(
            dtoData: data,
            workSpaceId: workSpaceId
        )
    }
    
}
