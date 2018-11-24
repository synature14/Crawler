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

    let clienURL = URL(string: "https://www.clien.net")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buyAndSellBoard = clienURL!.appendingPathComponent("/service/board/jirum")
        print("*** 사고팔고 url = \(buyAndSellBoard)")
        getData(url: buyAndSellBoard)
    }
    
    func getData(url: URL) {
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10) // DDOS 공격으로 인식됨을 방지, 15초마다 캐시 삭제
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard error == nil else {
                print("Error... \(String(describing: error))")
                return
            }
            
            if let _ = data, let _ = response as? HTTPURLResponse {
                self.updateHTML(url)
            }
        })
        
        dataTask.resume()
    }
    
    private func updateHTML(_ url: URL) {
        do {

            let tag = "(?<=<a href=\"/service/board/jirum/)([^\"]+)(?=\")"
            
            let reg = try NSRegularExpression(pattern: tag, options: .caseInsensitive)
            var urlList: [URL] = [url]
            
            while let toVisitUrl = urlList.popLast() {
                let contents = try String(contentsOf: url)
                // 필요한 내용 추출
                
                let matchedStrings = reg.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count))
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }
                
                for urlString in matchedStrings {
                    // URL 검증
                    // append
                    urlList.append(url)
                }
                
            }
            
//            let sub = contents.substring(with: NSRange(reg.))
            
//                contents.removeSubrange(NSRange(location: 0, length: contents.index))
            
//            "/service/board/jirum/12861426?od=T31&amp;po=1&amp;category=&amp;groupCd="
//            "/service/board/jirum/12861404?od=T31&amp;po=1&amp;category=&amp;groupCd="
//            "/service/board/jirum/12861371?od=T31&amp;po=1&amp;category=&amp;groupCd="
            
            
            let matchedStrings = reg.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }
                .map { urlList.append($0) }
            print(urlList)
            print(urlList.count)
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

