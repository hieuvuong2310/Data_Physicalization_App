//
//  SignUpViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-09-21.
//

import UIKit
import FirebaseAuth
import Firebase
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    @IBOutlet weak var teamMemberTitle: UILabel!
    
    @IBOutlet var backGround: UIView!
    
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        //Hide error label
        errorLabel.alpha = 0
        //Style the UI
        backGround.backgroundColor = UIColor.init(red: 250/255, green: 238/255, blue: 194/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 178/255, green: 139/255, blue: 80/255, alpha: 1)
        teamMemberTitle.textColor = UIColor.init(red: 178/255, green: 139/255, blue: 80/255, alpha: 1)
        //style the text field
        Utilities.styleTextField(fullNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
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
                    ViewController().userId = result!.user.uid
                    db.collection("users").document(result!.user.uid).setData(["fullName": fullName, "uid":result!.user.uid, "role": "member"]){
                        (error) in
                        if error != nil{
                            //Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    self.transitionToHome()
                }
            }
        }
        
    }
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
