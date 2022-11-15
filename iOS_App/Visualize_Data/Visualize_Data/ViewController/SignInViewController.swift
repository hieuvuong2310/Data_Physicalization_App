//
//  SignInViewController.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-09-21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet var background: UIView!
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        //Hide error label
        errorLabel.alpha = 0
        //Style the UI
        background.backgroundColor = UIColor.init(red: 250/255, green: 238/255, blue: 194/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 178/255, green: 139/255, blue: 80/255, alpha: 1)
        //style the text field
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInButton)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func signInTapped(_ sender: Any) {
        //Validate text fields
        
        //Create clean version
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Sign in the user
        Auth.auth().signIn(withEmail: email, password: password){
            (result, error) in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else{
                let database = Firestore.firestore().collection("user").document(result!.user.uid)
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(result!.user.uid)
//                var role:String? = nil
                docRef.getDocument { (document, err) in
                    if let document = document, document.exists {
                        let dataDescription = document.data()
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = ("Document data: \(dataDescription)")
                        let role = dataDescription?["role"] as? String
                        if(role == "member"){
                            self.transitionToHome()
                        }else{
                            self.transitionToLeaderHome()
                        }
                        ViewController().userId = (dataDescription?["uid"] as? String ?? nil)!
//                        var result: Response?
//                        do{
//                            result = try JSONDecoder().decode(Response.self, from: dataDescription)
//                            let role = result["role"] as? String
//                            if(role == "member"){
//                                self.transitionToHome()
//                            }else{
//                                self.transitionToLeaderHome()
//                            }
//                        }
//                        catch{
//                            self.errorLabel.alpha = 1
//                            self.errorLabel.text = ("Failed to convert \(err?.localizedDescription)")
//                        }
                    } else {
                        print("Document does not exist")
                        self.errorLabel.alpha = 1
                        self.errorLabel.text = ("Error getting documents: \(err)")
                    }
                }
//                db.collection("users").getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        self.errorLabel.alpha = 1
//                        self.errorLabel.text = ("Error getting documents: \(err)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data()
//                            let uid = data["uid"] as? String
//                            let role = data["role"] as? String
//                            if(uid == result!.user.uid){
//                                if(role == "member"){
//                                    self.transitionToHome()
//                                }else{
//                                    self.transitionToLeaderHome()
//                                }
//                            }
//                        }
//                    }
//                }
            }
        }
    }
    
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToLeaderHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.leaderHomeViewController) as? LeaderHomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
}
