//
//  NetworkRouter.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
    
    /* ========== case ========== */
    /* === AUTH === */
    case refresh
    /* === USER === */
    case requestSignUp(_ sender: SignUpRequestDTO)
    case checkValidEmail(_ sender: CheckEmailValidationRequestDTO)
    case emailLoginRequest(_ sender: SignInRequestDTO)
    
    case logoutRequest
    
    case myProfileInfo
    
    
    /* === WORKSPACE === */
    case makeWorkSpace(_ sender: MakeWorkSpaceRequestDTO)
    case myWorkSpaces
    case myOneWorkSpace(_ sender: Int)  // workSpaceId
    case editWorkSpace(_ sender: EditWorkSpaceRequestDTO)
    case deleteWorkSpace(_ sender: Int) // workSpaceId
    case inviteWorkSpaceMember(_ sender: InviteWorkSpaceMemberRequestDTO)    // email
    case workSpaceMembers(_ sender: Int) // workSpaceId
    
    case leaveWorkSpace(_ sender: Int)  // workSpaceId
    case changeAdminWorkSpace(_ sender: ChangeAdminWorkSpaceRequestDTO)
    
    
    /* === CHANNEL === */
    case makeChannel(_ sender: MakeChannelRequestDTO)
    case workSpaceAllChannels(_ sender: Int) // workSpaceId
    case workSpaceMyChannels(_ sender: Int) // workSpaceId
    case oneChannel(_ sender: ChannelDetailRequestDTO)
    case editChannel(_ sender: EditChannelRequestDTO)
    case deleteChannel(_ sender: ChannelDetailRequestDTO)
    case makeChannelChatting(_ sender: MakeChannelChattingRequestDTO)
    case channelChattings(_ sender: ChannelChattingRequestDTO)
    case channelUnreadCount(_ sender: ChannelUnreadCountRequestDTO)
    
    case channelMembers(_ sender: ChannelDetailRequestDTO)
    case leaveChannel(_ sender: ChannelDetailRequestDTO)
    case changeAdminChannel(_ sender: ChangeAdminChannelRequestDTO)
    
    
    /* === DM === */
    case workSpaceDMs(_ sender: Int)    // workSpaceId
    
    case dmUnreadCount(_ sender: DMUnreadCountRequestDTO)
    
    
    
    
    
    
    /* === 2. path === */
    var path: String {
        switch self {
        // AUTH
        case .refresh:
            return "/v1/auth/refresh"
            
            
        // USER
        case .checkValidEmail:
            return "/v1/users/validation/email"
        case .requestSignUp:
            return "/v1/users/join"
        case .emailLoginRequest:
            return "/v1/users/login"
        case .logoutRequest:
            return "/v1/users/logout"
        case .myProfileInfo:
            return "/v1/users/my"
            
            
        // WORKSPACE
        case .makeWorkSpace:
            return "/v1/workspaces"
        case .myWorkSpaces:
            return "/v1/workspaces"
        case .myOneWorkSpace(let sender):
            return "/v1/workspaces/\(sender)"
        case .editWorkSpace(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)"
        case .deleteWorkSpace(let sender):
            return "/v1/workspaces/\(sender)"
        case .inviteWorkSpaceMember(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/members"
        case .workSpaceMembers(let sender):
            return "/v1/workspaces/\(sender)/members"
        case .leaveWorkSpace(let sender):
            return "/v1/workspaces/\(sender)/leave"
        case .changeAdminWorkSpace(let sender):
            return "/v1/workspaces/\(sender.id)/change/admin/\(sender.user_id)"
            
            
        // CHANNEL
        case .makeChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels"
        case .workSpaceAllChannels(let sender):
            return "/v1/workspaces/\(sender)/channels"
        case .workSpaceMyChannels(let sender):
            return "/v1/workspaces/\(sender)/channels/my"
            
            // * 임시 - 채널이름 인코딩 안되는게 있음 'B -> 1/17 modified'
        case .oneChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))"
        case .editChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))"
        case .deleteChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))"
        case .makeChannelChatting(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/chats"
            
        case .channelChattings(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/chats"
            
        case .channelUnreadCount(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/unreads"
        case .channelMembers(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/members"
        case .leaveChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/leave"
        case .changeAdminChannel(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/channels/\(self.encodingUrl(sender.channelName))/change/admin/\(sender.nextAdminUserId)"
            
            
            
        // DM
        case .workSpaceDMs(let sender):
            return "/v1/workspaces/\(sender)/dms"
            
        case .dmUnreadCount(let sender):
            return "/v1/workspaces/\(sender.workSpaceId)/dms/\(sender.dmRoomId)/unreads"
        }
    }
    
    
    /* === 3. header === */
    var header: HTTPHeaders {
        switch self {
        case .checkValidEmail, .emailLoginRequest, .requestSignUp:
            return [
                "Content-Type": "application/json",
                "SesacKey": APIKey.key
            ]
        case .makeWorkSpace, .editWorkSpace, .makeChannelChatting:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": KeychainStorage.shared.accessToken ?? "" ,
                "SesacKey": APIKey.key
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": KeychainStorage.shared.accessToken ?? "",
                "SesacKey": APIKey.key
            ]
        }
    }
    
    
    /* === 4. method === */
    var method: HTTPMethod {
        switch self {
        // AUTH
        case .refresh:
            return .get
            
        // USER
        case .checkValidEmail, .requestSignUp, .emailLoginRequest:
            return .post
        case .myProfileInfo, .logoutRequest:
            return .get
        
            
        // WORKSPACE
        case .makeWorkSpace, .inviteWorkSpaceMember:
            return .post
        case .myWorkSpaces, .myOneWorkSpace, .leaveWorkSpace, .workSpaceMembers:
            return .get
        case .deleteWorkSpace:
            return .delete
        case .editWorkSpace, .changeAdminWorkSpace:
            return .put
    
            
            
        // CHANNEL
        case .makeChannel, .makeChannelChatting:
            return .post
        case .workSpaceAllChannels, .workSpaceMyChannels, .oneChannel, .channelChattings, .channelMembers, .leaveChannel, .channelUnreadCount:
            return .get
        case .deleteChannel:
            return .delete
        case .editChannel, .changeAdminChannel:
            return .put
            
            
            
        // DMs
        case .workSpaceDMs, .dmUnreadCount:
            return .get
            
        }
    }
    
    
    /* === 5. parameter === */
    var parameter: [String: Any] {
        switch self {
        case .checkValidEmail(let sender):
            return [
                "email": sender.email
            ]
        case .requestSignUp(let sender):
            return [
                "email": sender.email,
                "password": sender.password,
                "nickname": sender.nickname,
                "phone": sender.phone,
                "deviceToken": sender.deviceToken
            ]
        case .emailLoginRequest(let sender):
            return [
                "email": sender.email,
                "password": sender.password,
                "deviceToken": sender.deviceToken
            ]
            
            
        // WORKSPACE
        case .makeWorkSpace(let sender):
            return [
                "name": sender.name,
                "description":  sender.description,
                "image": sender.image
            ]
        case .editWorkSpace(let sender):
            return [
                "name": sender.name,
                "description": sender.description,
                "image": sender.image
            ]
        case .inviteWorkSpaceMember(let sender):
            return [
                "email": sender.email
            ]
            
            
        // CHANNEL
        case .makeChannel(let sender):
            return [
                "name": sender.channelName,
                "description": sender.channelDescription
            ]
        case .editChannel(let sender):
            return [
                "name": sender.newChannelName,
                "description": sender.newDescription
            ]
        case .makeChannelChatting(let sender):
            return [
                "content": sender.content ??  "",
                "files": sender.files
            ]
        
        default:
            return [:]
        }
    }
    
    
    /* === 6. query === */
    var query: [String: String] {
        switch self {
        // CHANNEL
        case .channelChattings(let sender):
            return [
                "cursor_date": sender.cursor_date
            ]
        case .channelUnreadCount(let sender):
            return [
                "after": sender.after
            ]
            
        // DM
        case .dmUnreadCount(let sender):
            return [
                "after": sender.after
            ]
            
        default:
            return [:]
        }
    }
    
    
    /* === 7. MultiPart Form Data === */
    var multipart: MultipartFormData {
        
        if self.header["Content-Type"] == "multipart/form-data" {
            
            return makeMultiPartFormData()
        }
        
        return MultipartFormData()
    }
    
    
    /* === 최종. asURLRequest === */
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: APIKey.baseURL + path)!
        
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method

        
        // paramter
        if (method == .post || method == .put)
            && self.header["Content-Type"] != "multipart/form-data" {
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter)
            request.httpBody = jsonData
            
            return request
        }
        
        if (method == .get) {
            if let urlString = request.url?.absoluteString {
                var components = URLComponents(string: urlString)
                components?.queryItems = []
                
                for (key, value) in query {
                    components?.queryItems?.append(URLQueryItem(name: key, value: value))
                }
                
                if let newURL = components?.url {
                    var newURLRequest = URLRequest(url: newURL)
                    newURLRequest.headers = header
                    newURLRequest.method = method
                    
                    return newURLRequest
                }
            }
            
        }
        
        return request
    }
    
    
    private func makeMultiPartFormData() -> MultipartFormData {
        
        let multipartFormData = MultipartFormData()
        
        for (key, value) in self.parameter {
            // 이미지 데이터인 경우
            if let imageData = value as? Data {
                multipartFormData.append(
                    imageData,
                    withName: key,
                    fileName: "image.jpeg",
                    mimeType: "image/jpeg"
                )
                
            }
            
            else {
                multipartFormData.append(
                    "\(value)".data(using: .utf8)!,
                    withName: key
                )
            }
        }
        
        return multipartFormData
    }
    
    
    private func encodingUrl(_ text: String) -> String {
        
        return text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }
}
