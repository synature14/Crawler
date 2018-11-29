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
        
        self.title = title
        // 타이틀의 마지막 ": 클리앙" 을 삭제해줘야함
        self.title.trimmingCharacters(in: ["앙"])
        self.title.trimmingCharacters(in: ["리"])
        
        self.writer = writer
        self.purchaseLink = link
        self.image = image
        self.explain = explain
        self.uploadDate = date
    }
}


