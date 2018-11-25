//
//  PostViewController.swift
//  Crawler
//
//  Created by sutie on 25/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    static func create() -> PostViewController {
        if let vc = Bundle.main.loadNibNamed("PostDetailView", owner: nil, options: nil)?.first as? PostViewController {
            return vc
        }
        return UIViewController() as! PostViewController
    }

}
