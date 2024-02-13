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
import SocketIO
import MobileCoreServices


final class ChannelChattingViewController: BaseViewController {
    
    
    var interaction: UIDocumentInteractionController?
    
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
    
    
    
    
    
    /* ===== life cycle ===== */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 채널 이름이 없을 때 대응!! - 푸시 눌러서 바로 들어온 경우
        if viewModel.nameOfChannel() == nil {
            print("채널 이름이 없다!! 푸시 눌러서 넘어왔나봄!!")
            // 먼저 채널 이름 불러오고 시작함
            viewModel.setChannelName {
                self.setNavigation(self.viewModel.nameOfChannel()!)
                self.setNavigationButton()
                
                self.setPlusButton()
                self.setTableView()
                self.setTextView()
                self.setNewMessageToastView()
                
                self.bindVM()
                
                self.startObservingKeyboard()
            }
            
        } else {
            print("채널 이름이 있다!! 정상적으로 넘어왔나봄!!")
            self.setNavigation(self.viewModel.nameOfChannel()!)
            self.setNavigationButton()
            
            self.setPlusButton()
            self.setTableView()
            self.setTextView()
            self.setNewMessageToastView()
            
            self.bindVM()
            
            self.startObservingKeyboard()
        }


        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(#function)
        loadData()
        startObservingSocket()
        
        // 현재 보고 있는 채널 채팅방 저장 <- push 알림 방지
        print("현재 보고 있는 채널 채팅방 저장 <- push 알림 방지")
        viewModel.setNewCurrentChannelID()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print(#function)
        viewModel.disconnectSocket()
        removeObservingSocket()
        
        // 현재 보고 있는 채널 채팅방 초기화
        print("현재 보고 있는 채널 채팅방 초기화")
        viewModel.initCurrentChannelID()
    }
    
    
    deinit {    // 이거 지금 실행 안됨ㅠ
        print("채널 채팅 뷰 deinit!! - 지우는 noti observer 많음!")
        
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
    
    
    
    
    /* ===== set ===== */
    // 네비게이션 영역에 넣을 버튼
    let channelSettingButton = UIBarButtonItem(image: UIImage(named: "icon_list"), style: .plain, target: nil, action: nil)
    
    func setNavigationButton() {
        navigationItem.rightBarButtonItem = channelSettingButton
    }
    
    func setPlusButton() {
        mainView.chattingInputView.plusButton.addTarget(self , action: #selector(plusButtonClicked), for: .touchUpInside)
    }
    
    @objc func plusButtonClicked() {
        self.showActionSheetTwoSection(
            firstTitle: "사진 추가", firstCompletion: {
                self.showPHPicker()
            }, secondTitle: "파일 추가") {
                self.showDocumentPicker()
            }
    }
    
    
    func setTableView() {
        mainView.chattingTableView.delegate = self
        mainView.chattingTableView.dataSource = self
        mainView.chattingTableView.prefetchDataSource = self
    }
    
    func setTextView() {
        mainView.chattingInputView.chattingTextView.delegate = self
    }
    
    func setNewMessageToastView() {
        // 뷰 클릭에 대한 액션 -> 스크롤 맨 바닥으로 보낸다.
        // (기본 : 일단 뷰가 떠있다는 건 스크롤이 어느 정도 위에 있다는 뜻)
        
        
        /* 필요한 변수 */
        // 현재 nextPagination이 모두 끝난 상태인지
        
        
        /* 경우의 수 */
        // 1. 현재 nextPagination이 모두 끝난 상태
            // (1). scrollToBottom
        
        // 2. 현재 nextPagination이 아직 끝나지 않은 상태 (디비에서 더 꺼내올 게 있는 상태)
            // (1). fetchAllNextChattingData & chatArr append  (2). tableView reload  (3). scrollToBottom
        
        
        
        mainView.newMessageView.fakeButton.rx.tap
            .subscribe(with: self) { owner , _ in
                
                if owner.viewModel.isDoneNextPaginationMethod() {
                    // 1.
                    print("Next Pagination이 끝났습니다. 고대로 아래로 내려보냅니다")
                    owner.tableViewScrollToBottom()
                    owner.mainView.newMessageView.isHidden = true
                } else {
                    // 2.
                    print("Next Pagination이 아직 끝나지 않은 상태입니다. 디비에 있는거 싹 다 꺼낸 후에 아래로 내려보냅니다")
                    self.viewModel.fetchAllNextData {
                        owner.mainView.chattingTableView.reloadData()
                        owner.tableViewScrollToBottom()
                        owner.mainView.newMessageView.isHidden = true
                        
                    }
                }
            }
            .disposed(by: disposeBag)
    }
        
    
    /* ===== bind ===== */
    func bindVM() {
        
        /* === collectionView rx === */
        viewModel.fileData
            .bind(to: mainView.chattingInputView.fileImageCollectionView.rx.items(cellIdentifier: ChannelChattingInputFileImageCollectionViewCell.description(), cellType: ChannelChattingInputFileImageCollectionViewCell.self)) { (row, element, cell) in
                
                cell.designCell(element)
                
                cell.cancelButton.rx.tap
                    .subscribe(with: self) { owner , _ in
                        print("cancelButton Clicked")
                        
                        // viewModel의 imageData 배열의 row 번째 요소 제거
                        do {
                            var newArr = try owner.viewModel.fileData.value()
                            print("-- \(row) 번째 요소 지운다")
                            print("이전 : \(newArr)")
                            newArr.remove(at: row)
                            print("이전 : \(newArr)")
                            owner.viewModel.fileData.onNext(newArr)
                            
                        } catch {
                            print("이미지 데이터 에러 catch")
                        }
                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
        
        
        /* === Input / Output === */ // - 채팅 보내는 작업 진행
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
                switch result {
                case .success(let model):
                    // 채팅 보내기 성공 TODO
                    // 1. (VM) (필요 시 fetchAllNextData) + chatArr append
                    // 2. (VC) tableView reload
                    // 3. (VC) scrollToBottom
                    // 4. (VC) initInputView
                    

                    owner.mainView.chattingTableView.reloadData()
                    owner.tableViewScrollToBottom()
                    owner.mainView.chattingInputView.chattingTextView.text = ""
                    owner.viewModel.removeAllImages()   // -> showImageCollectionView output 받아서 레이아웃 및 textViewDidChange 실행
                    
                case .failure(let networkError):
                    print("여기서 전송 실패에 대한 처리를 해줄 수 있을 것 같다. 단, 그럼 보내는 requestModel을 저장하고 있어야 해")
                }
            }
            .disposed(by: disposeBag)
         
        
        
        // addNewChatData : 소켓 응답으로 새로운 채팅을 받았을 때
        output.addNewChatData
            .subscribe(with: self) { owner , newChat in
                
                // 해보자
                
                /* 필요한 변수 */
                // 1. 현재 스크롤 위치가 토스트메세지뷰를 띄울 위치인지, 아니면 아예 스크롤을 아래로 보내버릴 위치인지
                // 2. nextPagination이 모두 끝난 상태인지, 아니면 디비에서 더 꺼내올 게 있는지
                let showToastView = owner.viewModel.showNewMessageToast()
                let isDone = owner.viewModel.isDoneNextPaginationMethod()
                
                /* 경우의 수 */
                // 1. 스크롤 위치가 바닥이라는 건, 당연히 pagination이 모두 끝났어야 함. (안끝났으면 그게 이상)
                    // (1). 디비에 newChat 저장  (2). chatArr에 newChat 붙이고  (3). tableView reload  (4). scrollToBottom
                if !showToastView { // (isDone은 당연히 true)
                    print("case 1. 스크롤 위치가 바닥이다")
                    // (1). -> VM
                    // (2). -> VM
                    // (3).
                    owner.mainView.chattingTableView.reloadData()
                    // (4).
                    owner.tableViewScrollToBottom()
                }
                
                // 2. 스크롤 위치가 위, pagination 모두 끝남
                    // (1). 디비에 newChat 저장  (2). chatArr에 newChat 붙이고  (3). tableView reload  (4). showNewMessageToastView
                if showToastView && isDone {
                    print("case 2. 스크롤 위치가 위, pagination 모두 끝남")
                    // (1). -> VM
                    // (2). -> VM
                    // (3).
                    owner.mainView.chattingTableView.reloadData()
                    // (4).
                    owner.mainView.newMessageView.setUpView(newChat)
                }
                
                // 3. 스크롤 위치가 위, pagination 아직 안끝남
                    // (1). 디비에 newChat 저장 (2). showNewMessageToastView
                if showToastView && !isDone {
                    print("case 3. 스크롤 위치가 위, pagination 아직 안끝남")
                    // (1). -> VM
                    // (2).
                    owner.mainView.newMessageView.setUpView(newChat)
                }
                
                /* toastView를 클릭했을 때 이벤트는 저 위쪽에서 구현 */

            }
            .disposed(by: disposeBag)
        
    }
    
    
    /* ===== load data ===== */
    // - 뷰가 화면에 나올 때 (viewDidAppear, sceneDidBecomeActive)
    func loadData() {
        viewModel.loadData {
            self.mainView.chattingTableView.reloadData()
            self.tableViewScrollToSeperatorCell()
        }
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
        if indexPath.row == viewModel.seperatorCellIndex() {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingSeperatorTableViewCell.description(), for: indexPath) as? ChannelChattingSeperatorTableViewCell else { return UITableViewCell() }
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingTableViewCell.description(), for: indexPath) as? ChannelChattingTableViewCell else { return UITableViewCell() }
            
            cell.designCell(viewModel.dataForRowAt(indexPath))
            cell.chattingContentView.fileView1.delegate = self
            cell.chattingContentView.fileView2.delegate = self
            cell.chattingContentView.fileView3.delegate = self
            cell.chattingContentView.fileView4.delegate = self
            cell.chattingContentView.fileView5.delegate = self

            return cell
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("***** 스크롤뷰 디드스크롤 *****")
        
        // 1. 현재 스크롤이 바닥에 있는지 아닌지 (소켓으로 응답 받았을 때 newMessageToastView 여부)
        let isBottom = scrollView.contentSize.height - scrollView.contentOffset.y < 800
        viewModel.setUpIsScrollBottom(isBottom)         // 매번 함수 실행하는게 살짝 무리이려나..?
        
        // 1.5 스크롤이 아래로 내려왔으면, hidden 처리해주기
        // * 애니메이션이 안먹긴 하는데, 일단 넘어가
        if !viewModel.showNewMessageToast() {
            UIView.transition(
                with: self.mainView.newMessageView,
                duration: 1) {
                    self.mainView.newMessageView.isHidden = true
                }
        }
        
        
        
        
        
        // 2. pagination 진행.
        if viewModel.notLoadScrollPagination { return }
        
        let yPos = scrollView.contentOffset.y
        let delta = scrollView.contentSize.height - scrollView.contentOffset.y
        viewModel.yPos = yPos
        viewModel.delta = delta
//        print("yPos : \(yPos)")
        
        // 위로 pagination
        if yPos < 100 {
            viewModel.paginationPreviousData { cnt in
                let indexPaths = (0..<cnt).map { IndexPath(row: $0, section: 0) }
                self.mainView.chattingTableView.insertRows(at: indexPaths, with: .bottom)    // 아래에서 위로 추가된다는 애니메이션
            }
        }
        if yPos > 100 {
            viewModel.stopPreviousPagination = false
        }
        
        // 아래로 pagination
        if delta < 1000 {
            viewModel.paginationNextData { [weak self] cnt in
//                let arrCnt = self?.viewModel.numberOfRows() ?? 0
//                let indexPaths = (0..<cnt).map { IndexPath(row: $0 + arrCnt, section: 0) }
//                self?.mainView.chattingTableView.insertRows(at: indexPaths, with: .top)
//                self.mainView.chattingTableView.row
                
                self?.mainView.chattingTableView.reloadData()
            }
        }
        if delta > 1000 {
            viewModel.stopNextPagination = false
        }
        
 
//        /* 필요한 변수 */
//        // 1. 네트워크 통신이기 때문에 과호출 먹지 않게 막아줄 변수 필요
//        //    stopPreviousPagination / stopNextPagination -> 디비 로드 끝나고 배열에 붙이고 테이블뷰 늘어나면 값 초기화
//        // 2. 더 이상 pagination이 가능한지, 즉 디비에서 더 이상 꺼내올 데이터가 없는지 확인할 변수 필요
//        //    -> 아래 pagination이 불가능하면, 그때부터 socket 응답값 바로 배열에 추가.
//        //    isDonePreviousPagination / isDoneNextPagination
//        // 3. pagination의 기준이 되는 날짜&시간
//        //    previousOffsetDate / nextOffsetDate
//        
//        
//        print("*************************")
    }
    
    
}


// Observing (keyboard, socket)
extension ChannelChattingViewController {
    
    /* keyboard */
    private func startObservingKeyboard() {
        
        print("******** start Observing Keyboard **********")
        
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
        
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: nil,
            using: a
        )
    }
    private func a(_ notification: Notification) {
//        print("*** a ***")
//        
//        let key = UIResponder.keyboardFrameEndUserInfoKey
//        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
//        
//        print("keyboardFrame height : \(keyboardFrame.height)")
    }
    
    private func keyboardWillAppear(_ notification: Notification) {
        print("")
        print("*** keyboardWillAppear ***")
        
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("keyboardFrame height : \(keyboardFrame.height)")
        
//
        let height = keyboardFrame.height - 83 /*+ mainView.chattingInputBackView.frame.height*/
//        // inputView의 height은 필요가 없어.

        let currentOffset = mainView.chattingTableView.contentOffset.y
        
        let newOffset = max(currentOffset + height, 0)
        
        print("현재 offset : \(currentOffset)")
        print("새로운 offset : \(newOffset)")
        
        UIView.animate(withDuration: 0.25) {
            self.mainView.chattingTableView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
        }
    }
    
    private func keyboardWillDisappear(_ notification: Notification) {
        print("")
        print("*** keyboardWillDisappear ***")
            
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardFrame = notification.userInfo?[key] as? CGRect else { return }
        
        print("keyboardFrame height : \(keyboardFrame.height)")
        
        let keyboardHeight: CGFloat = 336
        
        let height = keyboardHeight - 83
        
        let currentOffset = mainView.chattingTableView.contentOffset.y
        
        let newOffset = currentOffset - height
        
        print("현재 offset : \(currentOffset)")
        print("새로운 offset : \(newOffset)")
        
        UIView.animate(withDuration: 0.25) {
            self.mainView.chattingTableView.setContentOffset(CGPoint(x: 0, y: newOffset), animated: false)
        }
    }
    
    
    /* socket */
    private func startObservingSocket() {
        // SceneDidBecomeActive에서 소켓 재연결의 필요성을 확인하고, 노티를 보낸다 -> loadData
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(socketReconnectAndReloadData),
            name: NSNotification.Name("socketShouldReconnect"),
            object: nil
        )
    }
    
    private func removeObservingSocket() {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name("socketShouldReconnect"),
            object: nil
        )
    }
    
    @objc
    private func socketReconnectAndReloadData() {
        print("Scene에서 연락 받음 : 다시 소켓 연결해야 함!\n")
        
        self.loadData()
    }
}

// PHPicker
extension ChannelChattingViewController: PHPickerViewControllerDelegate {
    
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
        
        // 개수가 넘어갔을 때, 얼럿 띄우고 강제종료
        guard let curCnt = try? viewModel.fileData.value() else { return }
        let enableCnt = 5 - curCnt.count
        if results.count > enableCnt {
            print("얼럿!!! - 파일 개수는 5개 이하로 보낼 수 있습니다~~~")
            return
        }
        
        
        // 선택한 순서에 맞게 넣어주기 위해 배열의 인덱스를 이용한다
//        var imageArr = Array(repeating: Data(), count: results.count)
        
        var imageArr = Array(
            repeating: FileDataModel(
                fileName: "image.jpeg",
                data: Data(),
                fileExtension: .jpeg
            ),
            count: results.count
        )
        
        var group = DispatchGroup()
        
        for (index, item) in results.enumerated() {
            
            group.enter()
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                    
                    guard let image = image as? UIImage else { return }
                    
                    guard let imageData = image.jpegData(compressionQuality: 0.001) else { return }
                    
                    imageArr[index].data = imageData
                    
//                    imageArr[index] = imageData
                    group.leave()
                }
            }
        }
        
        picker.dismiss(animated: true)
        
        
        group.notify(queue: .main) { [weak self] in
            guard var fileArr = try? self?.viewModel.fileData.value() else { return }
            
            fileArr.append(contentsOf: imageArr)
            
            self?.viewModel.fileData.onNext(fileArr)
        }
        
    }
}

// DocumentPicker
extension ChannelChattingViewController: UIDocumentPickerDelegate {
    
    func showDocumentPicker() {
        
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [

                .pdf, .gif, .avi, .zip, .text, .mp3, .movie
            ],
            asCopy: true
        )
        
        picker.delegate = self
        picker.allowsMultipleSelection = true
        present(picker, animated: true)
        
    
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // 개수가 넘어갔을 때, 얼럿 띄우고 강제종료
        guard let curCnt = try? viewModel.fileData.value() else { return }
        let enableCnt = 5 - curCnt.count
        if urls.count > enableCnt {
            print("얼럿!!! - 파일 개수는 5개 이하로 보낼 수 있습니다!!")
            return
        }

        
        // url : FileManager URL
        
        
        // 데이터 타입으로 변환
        var dataArr: [FileDataModel] = []
        for url in urls {
            if let fileName = url.absoluteString.extractFileName(),
               let fileExtension = url.absoluteString.fileExtension() {
                print("000")
                dataArr.append(
                    FileDataModel(
                        fileName: fileName,
                        data: (try? Data(contentsOf: url)) ?? Data(),
                        fileExtension: fileExtension
                    )
                )
            }
        }
        
        // 뷰모델에 데이터 추가
        guard var fileArr = try? viewModel.fileData.value() else { return }
        fileArr.append(contentsOf: dataArr)
        viewModel.fileData.onNext(fileArr)
    }
    
}

// private func
extension ChannelChattingViewController {
    private func tableViewScrollToBottom() {
        let indexPath = IndexPath(
            row: self.viewModel.numberOfRows() - 1,
            section: 0
        )
        self.mainView.chattingTableView.scrollToRow(
            at: indexPath,
            at: .bottom,
            animated: false
        )
    }
    
    private func tableViewScrollToSeperatorCell() {
        
        let row = viewModel.seperatorCellIndex()
        
        let indexPath = IndexPath(
            row: row,
            section: 0
        )
        self.mainView.chattingTableView.scrollToRow(
            at: indexPath,
            at: .middle,
            animated: false
        )
    }
}

extension ChannelChattingViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
//        print(indexPaths)
        
    }
    
}


// file open delegate
extension ChannelChattingViewController: FileOpenDelegate, UIDocumentInteractionControllerDelegate {
    func downloadAndOpenFile(_ fileURL: String) {
        print("파일 다운 및 열기 : \(fileURL)")
        
        // fileURL : 서버에서 주는 url
        
        
        // 1. 네트워크 통신으로 파일 Data 다운
        NetworkManager.shared.requestCompletionData(
            api: .downLoadFile(fileURL)) { response in
                switch response {
                case .success(let data):
                    print(data)
                    
                    // 마지막 '/' 기준 뒤 문자열로 파일 이름 정의
                    guard let fileName = fileURL.extractFileName() else { return }
                    
                    let fileManager = FileManager()
                    let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(fileName)")
                    
                    do {
                        try data.write(to: documentPath)
                    } catch {
                        print(error)
                    }
                    
                    
                    print("파일 경로 - \(documentPath)")
                    
                    DispatchQueue.main.async {
                        self.interaction = UIDocumentInteractionController(url: documentPath)
                        self.interaction?.delegate = self
                        self.interaction?.presentPreview(animated: true)
                    }
                    
                    
                    
                case .failure(let networkError):
                    print("에러 발생 : \(networkError)")
                }
            }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        
        interaction = nil
        
    }
    
    
}
