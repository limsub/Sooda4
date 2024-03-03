//
//  MyProfileViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 2/29/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

class MyProfileViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    
    
    
    
    
    struct Input {
        let loadData: PublishSubject<Void>
        
//        let aCoinButtonClicked: ControlEvent<Void>
//        let bCoinButtonClicked: ControlEvent<Void>
//        let cCoinButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let b: PublishSubject<Int>
    }
    
    func transform(_ input: Input) -> Output {
        let b = PublishSubject<Int>()
        
        
        // 1. 프로필 정보
        input.loadData
            .flatMap {
                NetworkManager.shared.request(
                    type: MyProfileInfoDTO.self,
                    api: .myProfileInfo
                )
            }
            .subscribe(with: self) { owner , result in
                print("*** 프로필 정보 ***")
                print(result)
            }
            .disposed(by: disposeBag)
        
        // 2. 새싹 아이템 리스트
        input.loadData
            .flatMap {
                NetworkManager.shared.request(
                    type: SeSACItemListResponseDTO.self,
                    api: .sesacStoreItemList
                )
            }
            .subscribe(with: self) { owner , result in
                print("*** 리스트 ***")
                print(result)
            }
            .disposed(by: disposeBag)
        
        

        
        return Output(
            b: b
        )
    }
    
    
    
}


// event
extension MyProfileViewModel {
    
}
