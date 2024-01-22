//
//  ChannelChattingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa


class ChannelChattingViewController: BaseViewController {
    
    let mainView = ChannelChattingView()
    
    
    
    private var viewModel: ChannelChattingViewModel!
    
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: ChannelChattingViewModel) -> ChannelChattingViewController {
        let vc = ChannelChattingViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    
    
    // 네비게이션 영역에 넣을 버튼
    let channelSettingButton = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: nil, action: nil)
    
    
    // 데이터 불러오라는 이벤트
    let loadData = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        setNavigation("하이")
        setNavigationButton()
        
//        bindVM()
//        loadData.onNext(())
        
        setTableView()
        setTextView()
        
        startObservingKeyboard()
        
        
        
        // Notification 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        
        viewModel.loadData {
            print("todo : 테이블뷰 리로드 및 스크롤 시점 잡아주기")
        }
        
        
        /* test */
        mainView.chattingInputView.sendButton.addTarget(self , action: #selector(makeChatting), for: .touchUpInside)
    }
    
    @objc
    func makeChatting() {
        viewModel.sendMessage(
            content: self.mainView.chattingInputView.chattingTextView.text,
            files: []) {
                print("hi")
            }
    }
    
    // Notification 핸들러
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            print("Keyboard animation duration: \(animationDuration) seconds")
        }
    }
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = channelSettingButton
        
        
        channelSettingButton.rx.tap
            .subscribe(with: self) { owner , _ in
                print("000")
            }
            .disposed(by: disposeBag)
    }
    
    func bindVM() {
        
        let input = ChannelChattingViewModel.Input(
            channelSettingButtonClicked: channelSettingButton.rx.tap
        )
        
        let output = viewModel.transform(input)
         
        
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
}


// 테이블뷰 테스트
extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print(#function)
        
        mainView.chattingInputView.fileImageCollectionView.isHidden.toggle()
        mainView.chattingInputView.setConstraints()
        self.textViewDidChange(mainView.chattingInputView.chattingTextView)
        
    }
    
    func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
    }
    
    func setTextView() {
        mainView.chattingInputView.chattingTextView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        // estimatedSize
        // 1줄일 때 31.6
        // 2줄일 때 47.3
        // 3줄일 때 62.6
        // 기준이 뭔데 이거
        // inputView 내부에 패딩 없애자
        
        // 한 줄 텍스트뷰 높이 38
        // -> 38 - 31.6 = 6.4 => 위아래 패딩 3.2 주자
        
        if estimatedSize.height > 65 {
            textView.isScrollEnabled = true
            return
        } else {
            textView.isScrollEnabled = false
            
            textView.constraints.forEach { constraint in
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingTableViewCell.description(), for: indexPath) as? ChannelChattingTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .white
                
        return cell
    }
}


extension ChannelChattingViewController {
    private func startObservingKeyboard() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: keyboardWillAppear
        )
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: keyboardWillDisappear
        )
    }
    
    private func keyboardWillAppear(_ notification: Notification) {
        
        // 1. tableView 레이아웃 (bottom이 키보드 top + 인풋뷰 height)
        // 2. 스크롤 시점(?)도 키보드 top + 인풋뷰 height만큼 올려줘야 함.
        
        
    
        
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("- 키보드 올라옴 - ")
        print("keyboardFrame.height : ", keyboardFrame.height)
        print("chattingBackView Frame.height : ", mainView.chattingInputBackView.frame.height)
    
        var height = keyboardFrame.height /*+ mainView.chattingInputBackView.frame.height*/
        // inputView의 height은 필요가 없어.
        
        print("총 올려야 하는 height : ", height)
        
        
        print("현재 스크롤 Offset : ", self.mainView.chattingTableView.contentOffset)
        
        let newOffset = CGPoint(
            x: self.mainView.chattingTableView.contentOffset.x,
            y: self.mainView.chattingTableView.contentOffset.y + height
        )
        
        print("새로운 스크롤 Offset : ", newOffset)
                
        UIView.animate(withDuration: 0.25) {
            self.mainView.chattingTableView.setContentOffset(
                newOffset,
                animated: true
            )
        }
        
        
        
        
        // 테이블뷰의 스크롤 조절
        mainView.chattingTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        mainView.chattingTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        
        // 살짝 더 올라가.... 이유가 뭘까
        
        mainView.setConstraints()
    }
    
    private func keyboardWillDisappear(_ notification: Notification) {
        
        
            
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("- 키보드 내려감 - ")
        print("keyboardFrame.height : ", keyboardFrame.height)
        
        let height: CGFloat = 336 /*keyboardFrame.height*/
    
        print("현재 스크롤 Offset : ", self.mainView.chattingTableView.contentOffset)
        
        let newOffset = CGPoint(
            x: self.mainView.chattingTableView.contentOffset.x,
            y: self.mainView.chattingTableView.contentOffset.y - height
        )
        
        print("새로운 스크롤 Offset : ", newOffset)
                
        UIView.animate(withDuration: 0.25) {
            self.mainView.chattingTableView.setContentOffset(
                newOffset,
                animated: true
            )
        }
        
        mainView.setConstraints()
    }
}
