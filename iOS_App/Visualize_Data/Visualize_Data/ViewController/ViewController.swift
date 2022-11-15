//
//  ViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-09-21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    public var userId: String = ""
    public var url: String = "http://127.0.0.1:5001/data-visualization-proje-d998b/us-central1/app/api/"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //style the button
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(signInButton)

    }


}

