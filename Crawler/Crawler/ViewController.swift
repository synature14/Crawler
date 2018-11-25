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

    let buyAndSellBoard = URL(string: "https://www.clien.net/service/board/jirum/")!
    let tableView = UITableView()
    var visitedURL: Set<URL>! {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    static func create() -> ViewController {
        return ViewController()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
