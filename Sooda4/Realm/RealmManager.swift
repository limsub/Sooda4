//
//  RealmManager.swift
//  Sooda4
//
//  Created by 임승섭 on 1/29/24.
//

import Foundation
import RealmSwift

protocol RealmManagerProtocol {
    
}

class RealmManager: RealmManagerProtocol {
    // 싱글톤x
    
    private var realm: Realm?
    
    init() {
        // Manager 클래스 생성 시점에 keychain에 저장된 userID를 기반으로 realm 파일 선언
        // 기존에 있으면 있는거 쓰고, 없으면 새로 생성하게 된다
        
        guard let userId = KeychainStorage.shared._id else {
            self.realm = nil
            return
        }
        
        let realmFileName = "user_\(userId).realm"
        let realmURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(realmFileName)
        let config = Realm.Configuration(fileURL: realmURL)
       
        self.realm = try! Realm(configuration: config)
        
//        print("----- \(userId) realm 파일 생성 -----")
//        print(realm?.configuration.fileURL)
    }
}


/* ===== 채널 채팅 ===== */
// C - 채널 채팅 데이터 추가
extension RealmManager {
    // 0. 채팅 정보를 디비에 저장
    func addChannelChattingData(dtoData: ChannelChattingDTO, workSpaceId: Int) {
        
        guard let realm else { return }
        
        /* 디비에 저장하려고 하는 채팅이 이미 디비에 있는 채팅인지 확인하는 작업 */
        // 0. 디비에 저장하려고 하는 채팅이 이미 디비에 있는 채팅인지 확인하는 작업
            // - 서버 오류로 인해 중복된 채팅을 받을 가능성이 있음
            // - (현재는) createdAt을 주었을 때 해당 채팅을 포함해서 주기 때문에 필요하기도 함.
            // - request를 보냄과 동시에 소켓이 오픈되기 때문에, 서버 입장에서 request를 받기 전, 소켓을 통해 이미 디비에 채팅이 저장될 가능성이 있음.
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
        
    }
}


// R - 채널 채팅
extension RealmManager {
    
    // 1. 채널 채팅 중 가장 마지막 날짜 확인.
    func checkChannelChattingLastDate(requestModel: ChannelDetailFullRequestModel) -> Date? {
        
        guard let realm else { return nil }
        
        return realm.objects(ChannelChattingInfoTable.self)
            .filter("channelInfo.channel_id == %@", requestModel.channelId)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .first?
            .createdAt
    }
    
    
    // 2 - 1. targetDate 포함 (or NOT) 이전 데이터 최대 30개
    func fetchPreviousData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?, isFirst: Bool) -> [ChannelChattingInfoModel] {
        
        // lastChattingDate가 nil이다
        // -> (createdAt <= %@)디비에 저장된 읽은 데이터가 없다
        guard let targetDate else { return [] }
        guard let realm else { return [] }
        
        
        return realm.objects(ChannelChattingInfoTable.self)
            .filter(
                isFirst
                ? "channelInfo.channel_id == %@ AND createdAt <= %@"
                : "channelInfo.channel_id == %@ AND createdAt < %@",
                requestModel.channelId, targetDate
            )
            .sorted(byKeyPath: "createdAt")
            .suffix(30)
            .map { $0.toDomain() }
    }
    
    
    // 2 - 2. targetDate 포함 x 이후 데이터 최대 30개
    func fetchNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChannelChattingInfoModel] {
        
        guard let realm else { return [] }
        
        // lastChattingDate가 nil이다
        // -> (createdAt > %@) 디비에 저장된 모든 데이터가 읽지 않은 데이터이다
        if let targetDate {
            return realm.objects(ChannelChattingInfoTable.self)
                .filter(
                    "channelInfo.channel_id == %@ AND createdAt > %@",
                    requestModel.channelId,
                    targetDate
                )
                .sorted(byKeyPath: "createdAt")
                .prefix(30)
                .map { $0.toDomain() }
        } else {
            return realm.objects(ChannelChattingInfoTable.self)
                .filter(
                    "channelInfo.channel_id == %@",
                    requestModel.channelId
                )
                .sorted(byKeyPath: "createdAt")
                .prefix(30)
                .map { $0.toDomain() }
        }
    }
    
    
    // 2 - 3. targetDate 포함 x 이후 데이터 모두 가져오기
    func fetchAllNextData(requestModel: ChannelDetailFullRequestModel, targetDate: Date?) -> [ChannelChattingInfoModel] {
        
        guard let realm else { return [] }
        
        if let targetDate {
            return realm.objects(ChannelChattingInfoTable.self)
                .filter(
                    "channelInfo.channel_id == %@ AND createdAt > %@",
                    requestModel.channelId,
                    targetDate
                )
                .sorted(byKeyPath: "createdAt")
                .map { $0.toDomain() }
        } else {
            return realm.objects(ChannelChattingInfoTable.self)
                .filter(
                    "channelInfo.channel_id == %@",
                    requestModel.channelId
                )
                .sorted(byKeyPath: "createdAt")
                .map { $0.toDomain() }
        }
    }
    
}


// U - 채널 정보 업데이트 (유저 리스트 포함)
extension RealmManager {
    
    func updateChannelInfo(dtoData: OneChannelResponseDTO) {
        
        guard let realm else { return }
        
        // 1. 채널 테이블
        let newChannelTable = ChannelInfoTable()
        newChannelTable.channel_id = dtoData.channel_id
        newChannelTable.workspace_id = dtoData.workspace_id
        newChannelTable.channel_name = dtoData.name
        
        do {
            try realm.write {
                realm.add(newChannelTable, update: .modified)
            }
        } catch {
            print("Realm update Error")
        }
        
        
        // 2. 유저 테이블
        dtoData.channelMembers.forEach { dtoData in
            let newUserTable = UserInfoTable(dtoData)
            
            do {
                try realm.write {
                    realm.add(newUserTable, update: .modified)
                }
            } catch {
                print("Realm update Error")
            }
        }
        
    }
    
}



/* ===== DM 채팅 ===== */

