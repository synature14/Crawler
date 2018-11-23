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

    let clienURL = URL(string: "https://www.clien.net/service/group/allsell")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: clienURL!)
    }
    
    func getData(url: URL) {
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15) // 15초마다 캐시 삭제
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
            let dataString = try String(contentsOf: url)
            let htmlData = NSString(string: dataString).data(using: String.Encoding.unicode.rawValue)
            let attributedString = try NSMutableAttributedString(data: htmlData ?? Data.init(),
                                                             options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html],
                                                             documentAttributes: nil)
            print(attributedString)

        } catch {
            // error
        }
    }
    


}

