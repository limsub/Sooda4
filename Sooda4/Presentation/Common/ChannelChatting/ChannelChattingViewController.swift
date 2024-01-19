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
        
        bindVM()
        loadData.onNext(())
        
        setTableView()
        setTextView()
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
            loadData: self.loadData,
            channelSettingButtonClicked: channelSettingButton.rx.tap
        )
        
        let output = viewModel.transform(input)
         
        
    }
}


// 테이블뷰 테스트
extension ChannelChattingViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        print(#function)
        
        mainView.chattingInputView.fileImageCollectionView.isHidden.toggle()
        mainView.chattingInputView.setConstraints()
        self.textViewDidChange(mainView.chattingInputView.chattingTextView)
        
//        mainView.chattingInputView.layoutSubviews()
//        mainView.chattingInputView.updateConstraints()
        
//        self.setConstraints()s
        
        
        
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelChattingTableViewCell.description(), for: indexPath) as? ChannelChattingTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .white
                
        return cell
    }
}
