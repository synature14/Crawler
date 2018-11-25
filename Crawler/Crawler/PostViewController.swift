//
//  PostViewController.swift
//  Crawler
//
//  Created by sutie on 25/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titlePattern = "(?<=<span>)([^]+)(?=</span>)"
//        let title = htmlParse(of: url, pattern: titlePattern)
    }
    
    private func htmlParse(of url: URL, pattern: String) -> String {
        
        do {
            let reg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let contents = try String(contentsOf: url)
            let matchedString = reg.matches(in: contents, options: [], range: NSRange(location: 0, length: contents.utf16.count))
                .compactMap { Range($0.range, in: contents) }
                .map { String(contents[$0]) }
            
            print(matchedString)
            
        } catch {
            // error
        }
        
        return ""
    }

}
