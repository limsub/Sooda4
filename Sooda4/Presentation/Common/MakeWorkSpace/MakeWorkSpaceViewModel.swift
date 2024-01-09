//
//  MakeWorkSpaceViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/9/24.
//

import Foundation
import RxSwift
import RxCocoa

enum ResultMakeWorkSpace {
    // 네트워크 콜 x
    case invalid
    // 아직 명세서가 안나와서 이렇게 해뒀다.
    // 만약 텍스트필드 포커스처럼 여러 개가 invalid하고, 그 중 하나를 전달해야 한다면
    // 여기서 그 하나를 전달하고, 각각 여러개는 Output 요소로 전달해야 함
    
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        return "토스트먹고싶당"
    }
}

class MakeWorkSpaceViewModel: BaseViewModelType {
    
    private var disposeBag = DisposeBag()
    private let makeWorkSpaceUseCase: MakeWorkSpaceUseCase
    
    var didSendEventClosure: ( (MakeWorkSpaceViewModel.Event) -> Void)?
    
    init(makeWorkSpaceUseCase: MakeWorkSpaceUseCase) {
        self.makeWorkSpaceUseCase = makeWorkSpaceUseCase
    }
    
    let imageData = PublishSubject<Data>()
    
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let enabledCompleteButton: BehaviorSubject<Bool>
        let resultLogin: PublishSubject<ResultMakeWorkSpace>
    }
    
    func transform(_ input: Input) -> Output {
        let enabledCompleteButton = BehaviorSubject(value: true)
        let resultLogin = PublishSubject<ResultMakeWorkSpace>()
        
        
        let requestModel = Observable.combineLatest(input.nameText, input.descriptionText, imageData) { v1, v2, v3 in
            return MakeWorkSpaceRequestModel(name: v1, description: v2, image: v3)
        }
        
        // descriptionText는 없어도 돼!
        

        requestModel.subscribe(with: self) { owner , value  in
            print(value)
        }.disposed(by: disposeBag)
        
        
        
        
        input.completeButtonClicked
            .withLatestFrom(requestModel)
            .flatMap { value in self.makeWorkSpaceUseCase.makeWorkSpaceRequest(value)
            }
            .subscribe(with: self) { owner , response in
                print(response)
                
                // 성공적으로 만들었다 -> 화면 전환 Home Default
                
                
                switch response {
                case .success(let model):
                    owner.didSendEventClosure?(.goHomeDefaultView(workSpaceId: 100))
                    
                case .failure(let networkError):
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            enabledCompleteButton: enabledCompleteButton,
            resultLogin: resultLogin
        )
    }
}

extension MakeWorkSpaceViewModel {
    enum Event {
        case goHomeDefaultView(workSpaceId: Int)
    }
}

