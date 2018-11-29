//
//  Post.swift
//  Crawler
//
//  Created by sutie on 25/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import Foundation

struct Post {
    var title: String
    var writer: String
    var purchaseLink: String?
    var image: [String]?
    var explain: String
    var price: String?
    var uploadDate: String
    
    init(title: String, writer: String, link: String?, image: [String]?, explain: String, date: String) {
        // price 정보 있으면 price에 넣기
    
        // 타이틀의 마지막 ": 클리앙" 을 삭제해줘야함
        var filteredTitle = ""
        do {
            let removeClienReg = try NSRegularExpression(pattern: "[^\"]+(?= : 클리앙)", options: .caseInsensitive)
            filteredTitle = removeClienReg.matches(in: title, options: [], range: NSRange(location: 0, length: title.utf16.count))
                .compactMap { Range($0.range, in: title) }
                .map { String(title[$0]) }.first!
            
            
        } catch {
            print(error)
        }
        
        self.title = filteredTitle
        self.writer = writer
        self.purchaseLink = link
        self.image = image
        self.explain = explain
        self.uploadDate = date
    }
}


