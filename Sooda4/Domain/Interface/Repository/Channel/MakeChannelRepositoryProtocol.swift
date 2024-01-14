//
//  MakeChannelRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa


protocol MakeChannelRepositoryProtocol {
    
    // (1). 채널 생성
    func makeChannelRequest(_ requestModel: MakeChannelRequestModel) -> Single< Result<WorkSpaceChannelInfoModel, NetworkError> >
}
