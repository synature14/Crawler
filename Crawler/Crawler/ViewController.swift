//
//  ViewController.swift
//  Crawler
//
//  Created by sutie on 23/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    let buyAndSellBoard = URL(string: "https://www.clien.net/service/board/jirum/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageURL = buyAndSellBoard!.absoluteString + "?&od=T31&po="
        print("*** pageURL = \(pageURL)")
        eachPage(of: pageURL)
    }
    
    func eachPage(of urlString: String) {
        for pageIndex in 0...10 {
            if let url = verifyURL(urlString: urlString + String(pageIndex)) {
                self.subURLs(url)
            }
        }
    }
    
    private func subURLs(_ url: URL) {
        do {

            let tag = "(?<=<a href=\"/service/board/jirum/)([^\"]+)(?=\")"
            
            let reg = try NSRegularExpression(pattern: tag, options: .caseInsensitive)
            var urlList: [URL] = [url]
            var visitedURL = Set<URL>()
            
            while urlList.popLast() != nil {
                let contents = try String(contentsOf: url)
                
                // 필요한 내용 추출
                let matchedStrings = reg.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count)) // NSString으로 변환하여 length값 읽는것과 동일한 방법
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }
                
                for urlString in matchedStrings {
                    // URL 검증
                    if let url = verifyURL(urlString: buyAndSellBoard!.absoluteString + urlString), !visitedURL.contains(url) {
                        urlList.append(url)
                        visitedURL.insert(url)
                    }
                }
            }
            print(visitedURL)
            print("총 \(visitedURL.count)개")

        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func verifyURL(urlString: String) -> URL? {
        if let url = URL(string: urlString) {
            return url
        }
        return nil
    }
}

