//
//  ChannelChattingViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/14/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI


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
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigation(viewModel.nameOfChannel())
        setNavigationButton()
        
        setPHPicker()
        setTableView()
        setTextView()
        
        bindVM()
        
        startObservingKeyboard()
        
        viewModel.loadData {
            print("todo : 테이블뷰 리로드 및 스크롤 시점 잡아주기")
            self.mainView.chattingTableView.reloadData()
        }
    }
    
    
    /* ===== set ===== */
    // 네비게이션 영역에 넣을 버튼
    let channelSettingButton = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: nil, action: nil)
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = channelSettingButton
    }
    
    func setPHPicker() {
        mainView.chattingInputView.plusButton.addTarget(self , action: #selector(pickerButtonClicked), for: .touchUpInside)
    }
    
    func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
    }
    
    func setTextView() {
        mainView.chattingInputView.chattingTextView.delegate = self
    }
        
    
    /* ===== bind ===== */
    func bindVM() {
        
        /* === collectionView rx === */
        viewModel.imageData
            .bind(to: mainView.chattingInputView.fileImageCollectionView.rx.items(cellIdentifier: ChannelChattingInputFileImageCollectionViewCell.description(), cellType: ChannelChattingInputFileImageCollectionViewCell.self)) { (row, element, cell) in
                
                cell.cancelButton.rx.tap
                    .subscribe(with: self) { owner , _ in
                        print("cancelButton Clicked")
                        
                        // viewModel의 imageData 배열의 row 번째 요소 제거
                        do {
                            var newArr = try owner.viewModel.imageData.value()
                            print("-- \(row) 번째 요소 지운다")
                            print("이전 : \(newArr)")
                            newArr.remove(at: row)
                            print("이전 : \(newArr)")
                            owner.viewModel.imageData.onNext(newArr)
                            
                        } catch {
                            print("이미지 데이터 에러 catch")
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        /* === Input / Output === */
        let input = ChannelChattingViewModel.Input(
            chattingText: mainView.chattingInputView.chattingTextView.rx.text.orEmpty,
            sendButtonClicked: mainView.chattingInputView.sendButton.rx.tap,
            channelSettingButtonClicked: channelSettingButton.rx.tap    // 네비게이션 (mainView x)
        )
        
        
        
        let output = viewModel.transform(input)
        
        
        output.showImageCollectionView
            .subscribe(with: self) { owner , value in
                owner.mainView.chattingInputView.fileImageCollectionView.isHidden = !value
                owner.mainView.chattingInputView.setConstraints()
                owner.textViewDidChange(owner.mainView.chattingInputView.chattingTextView)
            }
            .disposed(by: disposeBag)
        
        
        output.enabledSendButton
            .subscribe(with: self) { owner, value in
                owner.mainView.chattingInputView.sendButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        
        output.resultMakeChatting
            .subscribe(with: self) { owner , result in
                // 성공 시 스크롤 맨 아래로 + 텍스트뷰 지워주기
                switch result {
                case .success(let model):
                    print("--- VC : 채팅 전송 성공 ---")
                    print("* TODO ")
                    
                    print(" - 보낸 채팅 테이블뷰에 업데이트 -> (VM) 배열에 추가")
                    owner.mainView.chattingTableView.reloadData()
                    
                    print(" - 스크롤 맨 아래로 위치")
                    let indexPath = IndexPath(
                        row: owner.viewModel.numberOfRows() - 1,
                        section: 0
                    )
                    owner.mainView.chattingTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    
                    print(" - Input View 초기화")
                    owner.mainView.chattingInputView.chattingTextView.text = ""
                    owner.viewModel.removeAllImages()   // -> showImageCollectionView output 받아서 레이아웃 및 textViewDidChange 실행
                          
                    
                case .failure(let networkError):
                    print("여기서 전송 실패에 대한 처리를 해줄 수 있을 것 같다. 단, 그럼 보내는 requestModel을 저장하고 있어야 해")
                }
            }
            .disposed(by: disposeBag)
         
        
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

// TextView
extension ChannelChattingViewController: UITextViewDelegate {
    
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
}


// TableView
extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 일단 초반에는 웬만하면 seperator cell 나오는 걸로 하고, 안나와야 하는 경우에 대해서는 나중에 예외처리해보자
        
        if viewModel.isSeperatorCell(indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingSeperatorTableViewCell.description(), for: indexPath) as? ChannelChattingSeperatorTableViewCell else { return UITableViewCell() }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingTableViewCell.description(), for: indexPath) as? ChannelChattingTableViewCell else { return UITableViewCell() }
            
            cell.designCell(viewModel.dataForRowAt(indexPath))

            
            return cell
        }
        
    }
}


// Keyboard Observing
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

// PHPicker
extension ChannelChattingViewController: PHPickerViewControllerDelegate {
    
    @objc func pickerButtonClicked() {
        self.showPHPicker()
    }
    
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        if results.isEmpty { return }
        
        
        // 선택한 순서에 맞게 넣어주기 위해 배열의 인덱스를 이용한다
        var imageArr = Array(repeating: Data(), count: results.count)
        var group = DispatchGroup()
        
        for (index, item) in results.enumerated() {
            
            group.enter()
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                    
                    guard let image = image as? UIImage else { return }
                    
                    guard let imageData = image.jpegData(compressionQuality: 0.001) else { return }
                    
                    imageArr[index] = imageData
                    group.leave()
                }
            }
        }
        
        picker.dismiss(animated: true)
        
        
        group.notify(queue: .main) {
            self.viewModel.imageData.onNext(imageArr)
        }
        
    }
}