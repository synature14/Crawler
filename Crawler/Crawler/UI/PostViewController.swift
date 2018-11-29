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

extension PostViewController {
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
            var matchedImage: [String]?
            if contents.contains("<img class=\"fr-dib fr-fil\" src=\"") {
                let imageReg = try NSRegularExpression(pattern: "(?<=<img class=\"fr-dib fr-fil\" src=\")([^\"]+)", options: .caseInsensitive)
                matchedImage = imageReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }
                
            } else if contents.contains("(?<=<img src=\").+(?=class=\"fr-fic fr-dii)") {
                let imageReg = try NSRegularExpression(pattern: "(?<=<img src=\").+(?=class=\"fr-fic fr-dii)", options: .caseInsensitive)
                matchedImage = imageReg.matches(in: contents, options: [], range: NSRange(location: 0, length: contentsLength))
                    .compactMap { Range($0.range, in: contents) }
                    .map { String(contents[$0]) }
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
