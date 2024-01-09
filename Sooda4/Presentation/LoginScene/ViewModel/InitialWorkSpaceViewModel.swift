//
//  InitialWorkSpaceViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class InitialWorkSpaceViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    private let workSpaceUseCase: WorkSpaceUseCaseProtocol
    
    var didSendEventClosure: ( (InitialWorkSpaceViewModel.Event) -> Void)?
    
    init(workSpaceUseCase: WorkSpaceUseCaseProtocol) {
        self.workSpaceUseCase = workSpaceUseCase
    }
    
    
    struct Input {
        let xButtonClicked: ControlEvent<Void>
        let makeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let nothing: String
    }
    
    // TODO: - 회원가입 하고나면 토큰 업데이트시켜줘야함. 그거 아직 안했다잉
    // x 버튼 클릭 -> 워크스페이스 조회 -> 1개 이상인지 확인 -> goEmpty or goDefault
    
    func transform(_ input: Input) -> Output {
        
        
        // x 버튼 클릭 -> 워크스페이스 조회 -> 존재 여부 확인 -> goEmpty of goDefault
        input.xButtonClicked
            .flatMap { value in
                self.workSpaceUseCase.myWorkSpacesRequest()
            }
            .subscribe(with: self) { owner , response  in
                print(response)
                
                switch response {
                case .success(let model):
                    print("내가 속한 워크스페이스 조회 성공")
                    if model.isEmpty {
                        print("소속된 워크스페이스 없음. Home Empty 가자")
                        owner.didSendEventClosure?(.goHomeEmptyView)
                    } else {
                        print("소속된 워크스페이스 있음. Home Default로 가자")
                        let workSpaceId = model[0].workSpaceId
                        owner.didSendEventClosure?(.goHomeDefaultView(workSpaceId: workSpaceId))
                    }
                    
                case .failure(let error):
                    print("여기서 에러가 나면.. 좀 그러네")
                }
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        // 생성하기 버튼 클릭
        input.makeButtonClicked
            .subscribe(with: self) { owner , _ in
                owner.didSendEventClosure?(.presentMakeWorkSpaceView)
            }
            .disposed(by: disposeBag)
        
        
        return Output(nothing: "hi")
    }
    
}


extension InitialWorkSpaceViewModel {
    enum Event {
        case goHomeEmptyView
        case goHomeDefaultView(workSpaceId: Int)
        case presentMakeWorkSpaceView
    }
}
