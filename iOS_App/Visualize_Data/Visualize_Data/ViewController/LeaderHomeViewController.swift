//
//  LeaderHomeViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-10-15.
//

import UIKit
import SwiftUI

class LeaderHomeViewController: UIViewController {

    @IBOutlet var background: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        background.backgroundColor =  UIColor.init(red: 237/255, green: 189/255, blue: 249/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 137/255, green: 85/255, blue: 221/255, alpha: 1)
        // Do any additional setup after loading the view.
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
