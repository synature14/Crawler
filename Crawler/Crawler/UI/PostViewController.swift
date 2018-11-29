//
//  PostViewController.swift
//  Crawler
//
//  Created by sutie on 25/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post! {
        didSet {
            self.titleLabel.text = post.title
            self.contentLabel.text = post.explain
//            self.imageView.image = UIImage.  // url로 불러들인 이미지를 이미지뷰에 넣어야함
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
