//
//  ChannelChattingCellContentView3.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//



import UIKit
import SnapKit

class ChannelChattingCellContentView3: BaseView {
    
    // 프로필 이름 (필수)
    let nameLabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "옹골찬 고래밥"
        view.setAppFont(.caption)
        return view
    }()
    
    let stackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()
    
    
    // 채팅 레이블 (옵션)
    let contentLabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?저희 수료식이 언제였조? 1/20 맞나요? 영등포 캠퍼스가 어디에 있었죠?"
        view.setAppFont(.body)
        return view
    }()
    
    let contentBackView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.appColor(.brand_inactive).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    // 이미지 묶음 뷰 (옵션)
    var sampleView = {
        let view = ChannelChattingCellContentImageSetView()
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    // 파일 뷰 (최대 5개 - 이미지 없이 파일들만)
    var fileView1 = FileContentView()
    var fileView2 = FileContentView()
    var fileView3 = FileContentView()
    var fileView4 = FileContentView()
    var fileView5 = FileContentView()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [nameLabel, stackView].forEach { item in
            self.addSubview(item)
        }
        
        [contentBackView, sampleView, fileView1, fileView2, fileView3, fileView4, fileView5].forEach { item in
            stackView.addArrangedSubview(item)
        }
        
        contentBackView.addSubview(contentLabel)
    }
    
    var sampleViewSingleLine: Constraint? = nil // 2, 3
    var sampleViewDoubleLine: Constraint? = nil // 1, 4, 5
    
    
    override func setConstraints() {
        super.setConstraints()
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(18)
            make.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).inset(8)
            make.width.lessThanOrEqualTo(228)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        
        // contentLabel + contentBackView
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        
        // sampleView
        sampleView.snp.makeConstraints { make in
            make.width.equalTo(244)
            
            make.height.lessThanOrEqualTo(162)
            
            self.sampleViewSingleLine = make.height.equalTo(80).constraint
            self.sampleViewDoubleLine = make.height.equalTo(162).constraint
        }
        
        
        // fileView
        [fileView1, fileView2, fileView3, fileView4, fileView5].forEach { item in
            item.snp.makeConstraints { make in
                make.height.equalTo(60)
                make.width.equalTo(244)
            }
        }
   
    }
    
    
    
    func designView(_ sender: ChannelChattingInfoModel) {
        
        
        
//        // sender.files에 pdf 파일이 있을 때, fileContentView를 띄워주자
//        var flag = 0;
//        sender.files.forEach { str in
//            if str.hasSuffix(".pdf") || str.hasSuffix(".zip") || str.hasSuffix(".mov") || str.hasSuffix(".mp3") {
//                fileContentView.pdfURL = str
//                flag = 1;
//            }
//        }
//        if flag == 0 { fileContentView.isHidden = true }
//        else { fileContentView.isHidden = false }
        
        backgroundColor = .clear
        
//        backgroundColor = .red
        
//        stackView.backgroundColor = .lightGray
        
//        var fileExtensionArr = [".pdf", ".zip", ".mov", ".mp3", ".docx"]
        
        let fileExtensionArr = FileExtension.allCases
            .map { $0.extensionStr }
            .filter { $0 != ".jpeg" }
        
        var imageArr: [String] = []
        var fileArr: [String] = []
    
        for fileStr in sender.files {
            // 이미지 배열
            if fileStr.hasSuffix(".jpg") || fileStr.hasSuffix(".jpeg") || fileStr.hasSuffix(".png") {
                imageArr.append(fileStr)
            }
            
            fileExtensionArr.forEach { extensionType in
                if fileStr.hasSuffix(extensionType) {
                    fileArr.append(fileStr)
                }
            }
        }
        
//        print("*------------------------*")
//        print("파일 배열 : ", fileArr)
//        print("이미지 배열 : ", imageArr)
//        print("이미지 배열 Empty : ", imageArr.isEmpty)
//        print("*------------------------*")
        
        // 이미지 뷰 업데이트
        self.sampleView.updateView(imageArr)
        
        // 파일 뷰 업데이트
        let fileViewArr = [fileView1, fileView2, fileView3, fileView4, fileView5]
        for i in 0..<fileArr.count {
            fileViewArr[i].isHidden = false
            fileViewArr[i].fileURL = fileArr[i]
        }
        for i in fileArr.count..<5 {
            fileViewArr[i].isHidden = true
        }
        
        
        
        
        self.nameLabel.text = sender.userName
        self.contentLabel.text = sender.content
        
        self.nameLabel.setAppFont(.caption)
        self.contentLabel.setAppFont(.body)
        
        
        contentLabel.isHidden = false
        contentBackView.isHidden = false
        sampleView.isHidden = false
        
        // 이미지 x
        if imageArr.isEmpty {
            sampleView.isHidden = true
        }
        // 텍스트 x
        if sender.content!.isEmpty {
            contentLabel.isHidden = true
            contentBackView.isHidden = true
        }
        
        // 이미지뷰 높이
        if singleLine(imageArr.count) {
            sampleViewSingleLine?.activate()
            sampleViewDoubleLine?.deactivate()
        } else {
            sampleViewSingleLine?.deactivate()
            sampleViewDoubleLine?.activate()
        }
        
        
        func singleLine(_ cnt: Int) -> Bool {
            if cnt == 1 || cnt > 3 { return false }
            else { return true }
        }

        // 이거 없어도 되긴 한데, 일단 혹시 모르니까
        setNeedsLayout()
        layoutIfNeeded()
    }
    

}


