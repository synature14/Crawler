//
//  NavigationViewController.swift
//  Crawler
//
//  Created by sutie on 25/11/2018.
//  Copyright © 2018 sutie. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainVC = ViewController()
        self.viewControllers = [mainVC]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
