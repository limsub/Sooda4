//
//  ChannelChattingCellContentImageSetView.swift
//  Sooda4
//
//  Created by 임승섭 on 1/23/24.
//

import UIKit

class ChannelChattingCellContentImageSetView: BaseView {
    
    
    // 기본으로 이미지뷰 5개.
    // 메서드로 들어온 이미지뷰 개수에 따라 레이아웃 변경.
    // 높이는 2개밖에 없어서, 개수에 따라 ChannelChattingCellContentView에서 잡아줄 예정.
    // 아니면 여기서 잡고 상위 뷰에도 적용되면, 굳이 위에서 잡을 필요 없음
    
    static func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }

    let imageViews = Array(repeating: makeImageView(), count: 5)
    
    
    let a = UIImageView()
    let b = UIImageView()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        print("*--------------------*")
        imageViews.forEach { item in
            print("---------")
            print(item)
            self.addSubview(item)
        }
        print("*--------------------*")

        imageViews[0].backgroundColor = .yellow
        imageViews[1].backgroundColor = .black
        imageViews[2].backgroundColor = .green
        imageViews[3].backgroundColor = .blue
        imageViews[4].backgroundColor = .purple
//        
//        
//        imageViews[2].snp.makeConstraints { make in
//            make.edges.equalTo(self)
//        }
        
//        a.backgroundColor = .black
//        b.backgroundColor = .yellow
//        
//        self.addSubview(a)
//        self.addSubview(b)
//        
//        a.snp.makeConstraints { make in
//            make.size.equalTo(30)
//            make.center.equalTo(self)
//        }
//        b.snp.makeConstraints { make in
//            make.size.equalTo(30)
//            make.center.equalTo(self).offset(30)
//        }
        
//        set5Layout()
    }
    
    
    
    func updateView(_ files: [String]) {
        
        // text용
//        for i in 1...5 {
//            imageViews[i-1].image = UIImage(named: "sample\(i)")
//        }
        
//        // 레이아웃 초기화
//        imageViews.forEach { item in
//            item.snp.removeConstraints()
//        }
        
        // file이 없는 경우는 아예 상위 뷰에서 Hidden처리 해준다
        switch files.count {
        case 1: set1Layout()
        case 2: set2Layout()
        case 3: set3Layout()
        case 4: set4Layout()
        case 5: set5Layout()
        default: return
        }
        
        
        // 혹시 모르니까
//        setNeedsLayout()
//        layoutIfNeeded()
    }
}



// 각 케이스별로 이미지뷰 레이아웃 잡기
extension ChannelChattingCellContentImageSetView {
    
    func set1Layout() {
        for i in 1...4 { imageViews[i].isHidden = true }
        
        imageViews[0].snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(244)
            make.height.equalTo(160)    
            // 이걸 상수로 잡는게 일단 맘에 안들어
            // -> 상위 뷰에서 잡자.
        }
    }
    
    func set2Layout() {
//        for i in 2...4 { imageViews[i].isHidden = true }
        
        imageViews[0].snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
//            make.height.equalTo(80)
            make.trailing.equalTo(self.snp.centerX).inset(1)
        }
        imageViews[1].snp.makeConstraints { make in
            make.trailing.verticalEdges.equalTo(self)
            make.leading.equalTo(self.snp.centerX).inset(-1)
        }
    }
    
    func set3Layout() {
//        for i in 3...4 { imageViews[i].isHidden = true }
        
        imageViews[0].snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3).offset(-4/3)
        }
        imageViews[1].snp.makeConstraints { make in
            make.leading.equalTo(imageViews[0].snp.trailing).offset(2)
            make.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3).offset(-4/3)
        }
        imageViews[2].snp.makeConstraints { make in
            make.leading.equalTo(imageViews[1].snp.trailing).offset(2)
            make.verticalEdges.equalTo(self)
            make.width.equalTo(self).dividedBy(3).offset(-4/3)
        }
    }
    
    func set4Layout() {
//        for i in 4...4 { imageViews[i].isHidden = true }
        
        imageViews[0].snp.makeConstraints { make in
            make.leading.top.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2).offset(-1)
        }
        imageViews[1].snp.makeConstraints { make in
            make.trailing.top.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2).offset(-1)
        }
        imageViews[2].snp.makeConstraints { make in
            make.leading.bottom.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2).offset(-1)
        }
        imageViews[3].snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self)
            make.width.height.equalTo(self).dividedBy(2).offset(-1)
        }
    }
    
    func set5Layout() {
        imageViews[0].snp.makeConstraints { make in
            make.top.leading.equalTo(self)
            make.height.equalTo(self).dividedBy(2).offset(-1)
            make.width.equalTo(self).dividedBy(3).offset(-4/3)
        }
        imageViews[1].snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(imageViews[1].snp.trailing).offset(2)
            make.height.width.equalTo(imageViews[0])
        }
        imageViews[2].snp.makeConstraints { make in
            make.top.equalTo(self)
            make.leading.equalTo(imageViews[1].snp.trailing).offset(2)
            make.height.width.equalTo(imageViews[0])
        }
        
        imageViews[3].snp.makeConstraints { make in
            make.bottom.leading.equalTo(self)
            make.height.width.equalTo(self).dividedBy(2).offset(-1)
        }
        imageViews[4].snp.makeConstraints { make in
            make.bottom.trailing.equalTo(self)
            make.height.width.equalTo(imageViews[3])
        }
    }
}