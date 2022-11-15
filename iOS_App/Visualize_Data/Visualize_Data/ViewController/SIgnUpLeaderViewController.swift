//
//  SIgnUpLeaderViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-09-28.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SIgnUpLeaderViewController: UIViewController {

    @IBOutlet weak var teamLeaderTitle: UILabel!
    
    @IBOutlet var background: UIView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide error label
        errorLabel.alpha = 0
        //Style the UI
        background.backgroundColor = UIColor.init(red: 237/255, green: 189/255, blue: 249/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 137/255, green: 85/255, blue: 221/255, alpha: 1)
        teamLeaderTitle.textColor = UIColor.init(red: 137/255, green: 85/255, blue: 221/255, alpha: 1)
        //style the text field
        Utilities.styleTextField(fullNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledLeaderButton(signUpButton)
        
    }
    //Check the fields and validate the data is correct. If everything is correct, this method return nil . Otherwise, it returns the error
    func validateFields()->String?{
        
        //Check that all fields are filled in
        if fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        //Check if the password is valid
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword)==false{
            return "Please make sure your passord is at least 8 characters, contains a special character and a number."
        }
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil{
            //There's something wrong with the fields, show error message
            showError(error!)
        }else{
            //Create clean versions of the data
            let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //Create the user
            Auth.auth().createUser(withEmail: email, password: password){
                (result, err) in
                if err != nil{
                    self.showError("Error creating user")
                }else{
                    let db = Firestore.firestore()
//                    let authData = Authentication(fullName: fullName, role: "leader", uid: result!.user.uid)
                    Authentication.fullName = fullName
                    Authentication.role = "leader"
                    Authentication.uid = result!.user.uid
//                    ViewController().userId = result!.user.uid
                    db.collection("users").document(result!.user.uid).setData(["fullName": fullName, "uid":result!.user.uid, "role": "leader"]){
                        (error) in
                        if error != nil{
                            //Show error mess
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    self.transitionToProjectRegistration()
                }
            }
        }
        
    }
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToProjectRegistration(){
        let projectViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.projectRegisViewController) as? ProjectRegistrationViewController
        view.window?.rootViewController = projectViewController
        view.window?.makeKeyAndVisible()
    }
    
//    func writeData(userEmai: String, userPassword: String, fullName: String, UDID: Any){
//        let docRef = database.collection("user").document(UDID).setData([
//            "fullName": fullName,
//            "UID": UDID,
//            "email": userEmail,
//            "password": userPassword
//        ])
        

}
