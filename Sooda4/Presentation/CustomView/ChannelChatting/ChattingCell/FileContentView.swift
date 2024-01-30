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


class FileContentView: BaseView {
    
    weak var delegate: FileOpenDelegate?
    
    var pdfURL: String? {
        didSet {
            fileOpenButton.setTitle(pdfURL, for: .normal)
        }
    }
    
    let fileOpenButton = UIButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(fileOpenButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        fileOpenButton.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(4)
        }
    }
    
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .red
        
        fileOpenButton.backgroundColor = .white
        fileOpenButton.setTitleColor(.black, for: .normal)
        
        fileOpenButton.addTarget(self, action: #selector(fileOpenButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func fileOpenButtonClicked() {
        guard let pdfURL else  { return }
        
        delegate?.downloadAndOpenFile(pdfURL)
    }

}
