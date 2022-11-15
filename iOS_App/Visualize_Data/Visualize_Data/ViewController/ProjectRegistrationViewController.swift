//
//  ProjectRegistrationViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-10-17.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProjectRegistrationViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var totalActivitiesTextField: UITextField!
    @IBOutlet weak var totalMemberTextField: UITextField!
    @IBOutlet weak var teamLeaderTitle: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activitiesQuantityTitle: UILabel!
    @IBOutlet weak var memberQuantityTitle: UILabel!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var projectNameTitle: UILabel!
    @IBOutlet weak var pageTitle: UILabel!
    
    var userId = Authentication.uid
    var appUrl = ViewController().url

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        background.backgroundColor = UIColor.init(red: 237/255, green: 189/255, blue: 249/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 137/255, green: 85/255, blue: 221/255, alpha: 1)
        teamLeaderTitle.textColor = UIColor.init(red: 137/255, green: 85/255, blue: 221/255, alpha: 1)
        Utilities.styleTextField(projectNameTextField)
        Utilities.styleTextTitle(activitiesQuantityTitle)
        Utilities.styleTextTitle(memberQuantityTitle)
        Utilities.styleTextTitle(projectNameTitle)
        Utilities.styleFilledLeaderButton(saveButton)
    }
    
    func validateFields()->String?{
        //Check that all fields are filled in
        if projectNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            totalMemberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)  == "" ||
            totalActivitiesTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  == ""{
            return "Please fill in all fields"
        }
        
        return nil
    }

    @IBAction func saveTapped(_ sender: Any) {
        //Save the data in the field to database with the collection "project" and document will have the id
        //Validate the fields
        let error = validateFields()

        if error != nil{
            //There's something wrong with the fields, show error message
            showError(error!)
        }else{
            let projectName = projectNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let memberQty = totalMemberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let activitiesQty = totalActivitiesTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let projectData = ProjectRegis(leader: self.userId, projectName: projectName, projectPeople: memberQty, projectActivities: activitiesQty)
            let postRequest = APIRequest(endpoint: "leader/\(self.userId)/projectInfo")
            postRequest.save(projectData, completion: { result in
                switch result{
                case .success(let projectData):
                    print("The item has been successfully saved \(projectData)")
                case .failure(let error):
                    print("An error occurs: \(error)")
                }
            })
            self.transitionToHome()
        }
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.leaderHomeViewController) as? LeaderHomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
