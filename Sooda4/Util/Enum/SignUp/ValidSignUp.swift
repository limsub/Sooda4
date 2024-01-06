//
//  ValidSignUp.swift
//  Sooda4
//
//  Created by 임승섭 on 1/6/24.
//

import Foundation

// 이메일
enum ValidEmail {
    case nothing
    case invalidFormat
    case validFormatNotChecked
    case checkFailed    // 중복된 이메일 (네트워크 응답: 에러)
    case available
}

// 닉네임, 연락처, 비밀번호, 비밀번호 확인은 모두 case 3개이기 때문에 하나로 합친다
// 지만, 각 케이스에 대해 다 토스트 메세지를 띄워줘야 하기 때문에 걍 따로 쓰쟈
//enum ValidComponent {
//    case nothing
//    case invalid
//    case valid
//}

enum ValidNickname {
    case nothing
    case invalidFormat
    case available
}

enum ValidPhoneNum {
    case nothing
    case invalidFormat
    case available
}

enum ValidPassword {
    case nothing
    case invalidFormat
    case available
}

enum ValidCheckPassword {
    case nothing
    case incorrect
    case correct
}
