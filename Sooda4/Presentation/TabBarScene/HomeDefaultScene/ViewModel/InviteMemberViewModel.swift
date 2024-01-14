//
//  InviteViewModel.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import Foundation
import RxSwift
import RxCocoa


// 안되는 경우
// 1. 권한 없음 (E14) - 워크스페이스 관리자 x -> 얜 왜들어온거야 그럼 -> 아마 처음부터 막지 않을까 싶은데
// 2. 알 수 없는 계정 (E03) - 이메일로 가입한 유저가 없을듯
// 3. 존재하지 않는 데이터 (E13) - 워크스페이스 아이디(Int)가 이상함 -> 이게 나오면 좀 당황스럽겠는데
// 4. 중복 데이터 (E12) - 이미 초대되어 있는 이메일을 입력함
// 5. 잘못된 요청 (E11) - 이메일 형식이 이상함

enum ResultInviteMember {
    case invalid    // 이메일 형식 이상함 (E11은 여기서 알아서 걸러야해)
    
    case success    // 굿
    
    case failure(error: NetworkError)
    
    var toastMessage: String {
        switch self {
        case .invalid:
            return "이메일 형식 맞춰라"
        case .success:
            return "SUCCESS"
        case .failure(let netWorkError):
            switch netWorkError {
            case .E03:
                return "이메일로 가입한 유저가 없음. 알 수 없는 계정"
            case .E12:
                return "이미 가입한 유저임"
            case .E13:
                return "존재하지 않는 워크스페이스 아이디"
            case .E15:
                return "워크스페이스 관리자만 초대할 수 있다. 돌아가라"
            
            default:
                return "에러가 발생했습니다. 잠시 후에 다시 시도해주세요"
            }
            
        }
    }
}

class InviteMemberViewModel: BaseViewModelType {
    
    var didSendEventClosure: ( (InviteMemberViewModel.Event) -> Void )?
    private var disposeBag = DisposeBag()
    
//    private let inviteMemberUseCase:
    private let inviteMemberUseCase: 
    
    struct Input {
        let emailText: ControlProperty<String>
        let completeButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let enabledCompleteButton: PublishSubject<Bool>
        let resultInviteMember: PublishSubject<ResultInviteMember>
    }
    
    func transform(_ input: Input) -> Output {
        
        let enabledCompleteButton = PublishSubject<Bool>()
        let resultInviteMember = PublishSubject<ResultInviteMember>()
        
        // 이메일 형식 검증 및 버튼 활성화
        let validEmail = PublishSubject<Bool>()
        input.emailText
            .subscribe(with: self) { owner , value in
                // 이메일 형식
//                validEmail.onNext(/*usecase.check(value)*/)
                
                // 버튼 활성화
                enabledCompleteButton.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        
        
        
        
        return Output(
            enabledCompleteButton: enabledCompleteButton,
            resultInviteMember: resultInviteMember
        )
    }
}

extension InviteMemberViewModel {
    enum Event {
        case goBackHomeDefault
    }
}
