//
//  SignUpBothViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-09-28.
//

import UIKit

class SignUpBothViewController: UIViewController {

    @IBOutlet weak var teamLeaderButton: UIButton!
    
    @IBOutlet weak var teamMemberButton: UIButton!
    
    @IBOutlet weak var backButton: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //style the button
        Utilities.styleFilledButton(teamMemberButton)
        Utilities.styleFilledLeaderButton(teamLeaderButton)

    }

}
