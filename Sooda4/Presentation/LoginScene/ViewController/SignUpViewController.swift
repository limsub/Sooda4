//
//  SignUpViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/5/24.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    deinit {
        for _ in 0...100 {
            print("SignUP Deinit~~~")
        }
    }
    
    private let mainView = SignUpView()
    private var viewModel: SignUpViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: SignUpViewModel) -> SignUpViewController {
        let vc = SignUpViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation("회원가입")
        bindVM()
    }

    
    func bindVM() {
        let input = SignUpViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty,
            nicknameText: mainView.nicknameTextField.rx.text.orEmpty,
            phoneNumText: mainView.phoneNumTextField.rx.text.orEmpty,
            pwText: mainView.pwTextField.rx.text.orEmpty,
            checkPwText: mainView.checkPwTextField.rx.text.orEmpty,
            emailValidButtonClicked: mainView.checkEmailValidButton.rx.tap,
            completeButtonClicked: mainView.completeButton.rx.tap
        )

        let output = viewModel.transform(input)

        
        
        // 이메일 중복 확인 버튼 enabled
        output.enabledEmailValidationButton
            .subscribe(with: self) { owner , value in
                owner.mainView.checkEmailValidButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        // 가입하기 버튼 enabled
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        /* === 이메일 유효성 검증 버튼 눌렀을 때 -> 토스트 메세지 띄워주기 용 === */
        output.resultValidEmailCheck
            .subscribe(with: self) { owner , value in
                print("--------")
                self.showToast(value.toastMessage)
            }
            .disposed(by: disposeBag)
        
        /* === 가입하기 버튼 눌렀을 때 -> invalid이면 레이블 빨간색 바꿔주기 === */
        // 1. 각각 valid 객체가 문제 있다 -> 레이블 빨간색
        // 2. resultSignUp의 정보 -> 텍스트필드 포커스 + 토스트 메세지
        // 1.
        output.validEmail
            .subscribe(with: self) { owner , value  in
                // .nothing -> 버튼 눌리지도 않아
                // .invalidFormat
                switch value {
                case .alreadyExistedEmail, .invalidFormat, .unknownedError:
                    print("이메일 빨간색 - ", value)
                    owner.mainView.emailTitleLabel.update(.disabled)
                case .validFormatNotChecked:
                    print("유효성 검사를 해주세요")
                    owner.mainView.emailTitleLabel.update(.disabled)
                    break;
                case .available:
                    owner.mainView.emailTitleLabel.update(.enabled)
                    
                default:
                    break;
                }
            }
            .disposed(by: disposeBag)
        
        output.validNickname
            .subscribe(with: self) { owner , value in
                switch value {
                case .invalidFormat:
                    print("닉네임 빨간색 - ", value)
                    owner.mainView.nicknameTitleLabel.update(.disabled)
                    
                case .available:
                    owner.mainView.nicknameTitleLabel.update(.enabled)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        output.validPhoneNum
            .subscribe(with: self) { owner , value in
                switch value {
                case .invalidFormat:
                    print("연락처 빨간색 - ", value)
                    owner.mainView.phoneNumTitleLabel.update(.disabled)
                    
                case .available:
                    owner.mainView.phoneNumTitleLabel.update(.enabled)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        output.validPassword
            .subscribe(with: self) { owner , value in
                switch value {
                case .invalidFormat:
                    print("비밀번호 빨간색 - ", value)
                    owner.mainView.pwTitleLabel.update(.disabled)
                    
                case .available:
                    owner.mainView.pwTitleLabel.update(.enabled)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        output.validCheckPassword
            .subscribe(with: self) { owner , value in
                switch value {
                case .incorrect:
                    print("비밀번호 확인 빨간색 - ", value)
                    owner.mainView.checkPwTitleLabel.update(.disabled)
                    
                case .correct:
                    owner.mainView.checkPwTitleLabel.update(.enabled)
                    
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        // 2.
        output.resultSignUp
            .subscribe(with: self) { owner , value in
                switch value {
                case .firstInvalidFormatComponent(let component):
                    // 포커스를 해줘야 함
                    switch component {
                    case .email: print("이메일 텍스트필드 포커스")
                    case .nickname: print("닉네임 텍스트필드 포커스")
                    case .phoneNum: print("연락처 텍스트필드 포커스")
                    case .pw: print("비밀번호 텍스트필드 포커스")
                    case .checkPw: print("비밀번호 확인 텍스트필드 포커스")
                    }
                    
                    // 토스트 메세지 띄워주기
                    self.showToast(value.toastMessage)
                    
                case .failure:
                    // 토스트 메세지 띄워주기
                    self.showToast(value.toastMessage)
                    
                // 성공일 때는 토스트 메세지 따로 띄우지 않는다
                    
                    
                default: break
                }
                
                
            }
            .disposed(by: disposeBag)
        
    }
    
    
    func showToast(_ message: String) {
        print("토스트 메세지 : \(message)")
    }
}
