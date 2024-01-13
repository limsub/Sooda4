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
    
    enum OperationType {
        case make
        case edit(workSpaceId: Int)
    }
    
    private var disposeBag = DisposeBag()
    private let makeWorkSpaceUseCase: MakeWorkSpaceUseCase
    let type: OperationType
    
    var didSendEventClosure: ( (MakeWorkSpaceViewModel.Event) -> Void)?
    
    init(makeWorkSpaceUseCase: MakeWorkSpaceUseCase, type: OperationType) {
        self.makeWorkSpaceUseCase = makeWorkSpaceUseCase
        self.type = type
    }
   
    let imageData = PublishSubject<Data>()
    

    
    
    struct Input {
        let nameText: ControlProperty<String>
        let descriptionText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let initialModel: PublishSubject<MyOneWorkSpaceModel>   // 만약 "수정하기"로 들어왓으면, 여기서 초기 데이터 전달. "생성하기"로 들어오면 아무 이벤트 x
        
        let enabledCompleteButton: BehaviorSubject<Bool>
        let resultLogin: PublishSubject<ResultMakeWorkSpace>
    }
    
    func transform(_ input: Input) -> Output {
        
        let initialModel = PublishSubject<MyOneWorkSpaceModel>()
        let enabledCompleteButton = BehaviorSubject(value: true)
        let resultLogin = PublishSubject<ResultMakeWorkSpace>()
        
        
        // "편집"일 때만! 초기 데이터 전달
        if case .edit(let workSpaceId) = type {
            print("- 편집하러 들어왔기 때문에 워크스페이스 정보 네트워크 콜 쏜다")
            Observable<Int>.just(workSpaceId)
                .flatMap { value in
                    self.makeWorkSpaceUseCase.myOneWorkSpaceInfoRequest(value)
                }
                .subscribe(with: self) { owner , response in
                    switch response {
                    case .success(let model):
                        initialModel.onNext(model)
                        
                    case .failure(let networkError):
                        print("에러났슈 : \(networkError.localizedDescription)")
                    }
                }
                .disposed(by: disposeBag)
        }
        // 이미지 데이터는 따로 프로퍼티가 있기 때문에 초기 데이터가 로드되었으면 바로 Data 받는다
        initialModel
            .flatMap {
                self.makeWorkSpaceUseCase.loadImageData(endURLString: $0.thumbnail)
            }
            .subscribe(with: self) { owner , response in
                switch response {
                case .success(let data):
                    self.imageData.onNext(data)
                    
                case .failure(let error):
                    print("에러났슈 : \(error)")
                }
            }
            .disposed(by: disposeBag)
        
        
        
        /* --- 테스트용 --- */
        input.nameText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print(" - nameText 인풋 이벤트 받음 : \(value)")
            }
            .disposed(by: disposeBag)
        input.descriptionText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                print(" - descriptionText 인풋 이벤트 받음 : \(value)")
            }
            .disposed(by: disposeBag)
        /* -------------- */
        
        //
        let requestModel = Observable.combineLatest(input.nameText, input.descriptionText, imageData) { v1, v2, v3 in
            return MakeWorkSpaceRequestModel(name: v1, description: v2, image: v3)
        }
        
        input.completeButtonClicked
            .withLatestFrom(requestModel)
            .flatMap { value in 
                self.makeWorkSpaceUseCase.makeWorkSpaceRequest(value)
            }
            .subscribe(with: self) { owner , response in
                print(response)
                
                // 성공적으로 만들었다 -> 화면 전환 Home Default
                
                
                switch response {
                case .success(let model):
                    
                    // 생성 시에는 추가적인 API 호출 없이 방금 만든 워크스페이스 페이지로 이동
                    let workSpaceId = model.workSpaceId
                    owner.didSendEventClosure?(.goHomeDefaultView(workSpaceId: workSpaceId))
                    
                case .failure(let networkError):
                    print("명세서 나오면 구현 예정")
                    break
                }
                
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            initialModel: initialModel,
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

