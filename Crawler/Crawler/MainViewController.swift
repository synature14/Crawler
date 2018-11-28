//
//  ViewController.swift
//  Crawler
//
//  Created by sutie on 23/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController {

    let buyAndSellBoard = URL(string: "https://www.clien.net/service/board/jirum/")!
    let tableView = UITableView()
    var visitedURL: Set<URL>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var postArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        let pageURL = buyAndSellBoard.absoluteString + "?&od=T31&po="
        print("*** pageURL = \(pageURL)")
        eachPage(of: pageURL)
    }
    
    func initUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        visitedURL = Set<URL>()
        
        let frame = CGRect(x: 0, y: 50, width: self.view.bounds.width, height: self.view.bounds.height - 50)
        tableView.frame = frame
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.separatorColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let cellNib = UINib(nibName: "ListTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ListTableViewCell")
        
        self.view.addSubview(tableView)
    }
    
    
    func eachPage(of urlString: String) {
        for pageIndex in 0...1 {
            if let url = verifyURL(urlString: urlString + String(pageIndex)) {
                self.subURLs(url)
            }
        }
    }
    
    private func subURLs(_ url: URL) {
        do {
            let pattern = "(?<=<a href=\"/service/board/jirum/)([^\"]+)(?=\")"
            
            let reg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            var urlList: [URL] = [url]
            
            while urlList.popLast() != nil {
                let contents = try String(contentsOf: url)
                
                // 필요한 내용 추출
                let matchedStrings = reg.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count)) // NSString으로 변환하여 length값 읽는것과 동일한 방법
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }
                
                for urlString in matchedStrings {
                    // URL 검증
                    let totalURLString = buyAndSellBoard.absoluteString + urlString
                    if let url = verifyURL(urlString: totalURLString), !visitedURL.contains(url) {
                        urlList.append(url)
                        visitedURL.insert(url)
                        extractContents(url: url)
                    }
                }
            }
            
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
    
    static func create() -> MainViewController {
        return MainViewController()
    }
}

extension MainViewController {
    // 컨텐츠 데이터 뽑아내기
    func extractContents(url: URL) {
        do {
            let contents = try String(contentsOf: url)
            let contentsLength = contents.utf16.count
            
            let pattern = "(?<=<title>)([^\"]+)(?=</title>)"
            let titleReg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matchedTitle = titleReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }.first!
            
            
            // nickname 여러개가 추출됨. 그중에서 첫번째가 작성자 닉네임
            let writerReg = try NSRegularExpression(pattern: "(?<=<span class=\"nickname\">)([^\"]+)(?=\")", options: .caseInsensitive)
            let matchedWriter = writerReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }.first!
            
            var writerInfo: String!
            
            // <img src=" 가 포함되면 image로 writer 표현해야함
            if matchedWriter.contains("<img src=") {
                let writerImageReg = try NSRegularExpression(pattern: "(?<=<img src=\")([^\"]+)(?=\" alt)", options: .caseInsensitive)
                writerInfo = writerImageReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }.first
                
            } else {    // 닉네임이 text일 경우
                let writerTextReg = try NSRegularExpression(pattern: "(?<=<span>)([^<]+)", options: .caseInsensitive)
                writerInfo = writerTextReg.matches(in: matchedWriter, options: [], range: NSRange(location: 0, length: matchedWriter.utf16.count))
                    .compactMap { Range($0.range, in: matchedWriter) }
                    .map { String(matchedWriter[$0]) }.first
            }

            
            let linkReg = try NSRegularExpression(pattern: "(?<=<span class=\"outlink\"><a class=\"url\" href=\")([^\"]+)", options: .caseInsensitive)
            let matchedLink = linkReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }.first
            
            
            // Contents body 부분 추출
            let contentsReg = try NSRegularExpression(pattern: "(?<=<meta name=\"description\" content=\")([^\"]+)", options: .caseInsensitive)
            let matchedContents = contentsReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }.first!
            
            
            // 이미지 소스 파싱
            var matchedImage: String?
            if contents.contains("<img class=\"fr-dib fr-fil\" src=\"") {
                let imageReg = try NSRegularExpression(pattern: "(?<=<img class=\"fr-dib fr-fil\" src=\")([^\"]+)", options: .caseInsensitive)
                matchedImage = imageReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }.first
                
            }
            
            
            // 업로드 날짜 파싱
            let dateReg = try NSRegularExpression(pattern: "(?<=<span class=\"fa fa-clock-o\"></span>)([^\"]+)(?=\n)", options: .caseInsensitive)
            let matchedDate = dateReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }.first!
            
            
            self.postArray.append(Post(title: matchedTitle, writer: writerInfo,
                                       link: matchedLink, image: matchedImage,
                                       explain: matchedContents, date: matchedDate))
            print("postArray 몇개: \(postArray.count)")
            print(postArray.last)
            print()
            
        } catch {
            // error
            print(error)
        }
        
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedURL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.property = visitedURL![visitedURL.index(visitedURL.startIndex, offsetBy: indexPath.row)].absoluteString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // PostVC로 이동해야함
        let postVC = PostViewController.create()
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    
}
