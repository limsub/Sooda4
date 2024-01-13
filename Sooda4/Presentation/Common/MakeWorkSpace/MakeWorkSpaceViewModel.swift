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
    case invalid(component: Component)
    
    // 네트워크 콜 o
    case success
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        switch self {
        case .invalid(let component):
            switch component {
            case .name:
                return "워크스페이스 이름음 1 ~ 30자로 설정해주세요"
            case .image:
                return "워크스페이스 이미지를 등록해주세요"
            }
        case .success:
            return "Success"
        case .failure(let error):
            switch error {
            case .E12:
                return "중복된 이름인 것 같아요"
            case .E21:
                return "새싹코인이 부족하다 임마"
            default:
                return "에러발생 에러발생 \(error)"
            }
        }
    }
    
    enum Component {
        case name, image
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
        let initialModel: PublishSubject<MyOneWorkSpaceModel>   
        // 만약 "수정하기"로 들어왓으면, 여기서 초기 데이터 전달. "생성하기"로 들어오면 아무 이벤트 x
        
        let enabledCompleteButton: BehaviorSubject<Bool>
        let resultMakeWorkSpace: PublishSubject<ResultMakeWorkSpace>
    }
    
    func transform(_ input: Input) -> Output {
        
        let initialModel = PublishSubject<MyOneWorkSpaceModel>()
        let enabledCompleteButton = BehaviorSubject(value: false)
        let resultMakeWorkSpace = PublishSubject<ResultMakeWorkSpace>()
        
        
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
                        print("0-----0")
                        print(model.thumbnail)
                        print("0-----0")
                        
                        // /static/workspaceThumbnail/1705103897177.png
                        // /static/workspaceThumbnail/1705122291159.png
                        // /static/workspaceThumbnail/1705122437325.jpeg
                        
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
        
        
        // 버튼 활성화 조건
        input.nameText
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value  in
                enabledCompleteButton.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        
        
        // Valid
        let validImage = BehaviorSubject<Bool>(value: false)
        let validName = PublishSubject<Bool>()
        
        imageData
            .subscribe(with: self) { owner , value in
                validImage.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        input.nameText
            .subscribe(with: self) { owner , value in
                if value.count > 0 && value.count < 31 {
                    validName.onNext(true)
                } else {
                    validName.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        // 워크스페이스 생성
        if case .make = type {
            let makeRequestModel = Observable.combineLatest(input.nameText, input.descriptionText, imageData) { v1, v2, v3 in
                return MakeWorkSpaceRequestModel(name: v1, description: v2, image: v3)
            }
            let validSet = Observable.combineLatest(validImage, validName)
            input.completeButtonClicked
                .withLatestFrom(validSet)
                .filter { value in
                    
                    if !value.0 {
                        resultMakeWorkSpace.onNext(.invalid(component: .image))
                        return false
                    } else if !value.1 {
                        resultMakeWorkSpace.onNext(.invalid(component: .name))
                        return false
                    } else {
                        return true
                    }
                }
                .withLatestFrom(makeRequestModel)
                .flatMap {
                    self.makeWorkSpaceUseCase.makeWorkSpaceRequest($0)
                }
                .subscribe(with: self) { owner, response in
                    switch response {
                    case .success(let model):
                        let workSpaceId = model.workSpaceId
                        owner.didSendEventClosure?(.goHomeDefaultView(
                            workSpaceId: workSpaceId)
                        )
                        
                    case .failure(let networkError):
                        resultMakeWorkSpace.onNext(.failure(error: networkError))
                    }
                }
                .disposed(by: disposeBag)
        }
        
        // 워크스페이스 수정
        if case .edit(let workSpaceId) = type {
            
            let editRequestModel = Observable.combineLatest(input.nameText, input.descriptionText, imageData) { v1, v2, v3 in
                return EditWorkSpaceRequestModel(workSpaceId: workSpaceId, name: v1, description: v2, image: v3)
            }
            input.completeButtonClicked
                .withLatestFrom(editRequestModel)
                .flatMap { value in
                    self.makeWorkSpaceUseCase.editWorkSpaceRequest(value)
                }
                .subscribe(with: self) { owner , response  in
                    switch response {
                    case .success:
                        print("기존 워크스페이스 수정!")
                        owner.didSendEventClosure?(.goBackWorkListView)
                        
                        
                    case .failure(let networkError):
                        print("에러났슈")
                    }
                }
                .disposed(by: disposeBag)
        }
        
        
        
        
        return Output(
            initialModel: initialModel,
            enabledCompleteButton: enabledCompleteButton,
            resultMakeWorkSpace: resultMakeWorkSpace
        )
    }
}



extension MakeWorkSpaceViewModel {
    enum Event {
        case goHomeDefaultView(workSpaceId: Int)
        case goBackWorkListView
    }
}

