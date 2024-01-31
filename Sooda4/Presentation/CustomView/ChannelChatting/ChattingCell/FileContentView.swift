//
//  FileContentView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/30/24.
//

import UIKit
import PDFKit

protocol FileOpenDelegate: AnyObject {
    func downloadAndOpenFile(_ fileURL: String)
}


// 244 x 60
class FileContentView: BaseView {
    
    weak var delegate: FileOpenDelegate?
    
    var fileURL: String? {
        didSet {
            self.setUp(fileURL: fileURL)
        }
    }
    
    let fileExtensionImageView = UIImageView()
    let fileNameLabel = {
        let view = UILabel()
        view.setAppFont(.body)
        return view
    }()
    let fakeButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(fileExtensionImageView)
        self.addSubview(fileNameLabel)
        self.addSubview(fakeButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        fileExtensionImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self).inset(10)
            make.width.equalTo(fileExtensionImageView.snp.height)
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(fileExtensionImageView.snp.trailing).offset(8)
            make.trailing.equalTo(self).inset(8)
            make.centerY.equalTo(self)
        }
        
        fakeButton.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.appColor(.brand_inactive).cgColor
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor

        fakeButton.addTarget(self, action: #selector(fileOpenButtonClicked), for: .touchUpInside)
    }
    
    func setUp(fileURL: String?) {
        
        guard let fileURL else { return }
        
        // 파일명 분리
        let components = fileURL.components(separatedBy: "/")
        if components.count < 3 { return }
        let fileName = components[components.count - 1]
        
        
        // 이미지 세팅
        FileExtension.allCases.forEach { fileExtension in
            if fileName.hasSuffix(fileExtension.extensionStr) {
                self.fileExtensionImageView.image = UIImage(named: fileExtension.imageName)
            }
        }
        
        
        // 레이블 세팅
        fileNameLabel.text = fileName
        fileNameLabel.setAppFont(.body)
    }
    
    
    @objc func fileOpenButtonClicked() {
        guard let fileURL else  { return }
        
        delegate?.downloadAndOpenFile(fileURL)
    }

}
