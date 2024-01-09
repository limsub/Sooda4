//
//  MakeWorkSpaceRepositoryProtocol.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MakeWorkSpaceRepositoryProtocol {
    // (1). 워크스페이스 생성
    func makeWorkSpaceRequest(_ requestModel: MakeWorkSpaceRequestModel) -> Single< Result<WorkSpaceModel, NetworkError> >
}
