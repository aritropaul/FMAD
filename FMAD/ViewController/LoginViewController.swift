//
//  LoginViewController.swift
//  FMAD
//
//  Created by Aritro Paul on 11/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var username = ""
    
    @IBAction func loginTapped(_ sender: Any) {
        
        username = usernameField.text ?? ""
        if (usernameField.text == "ARITRO" && passwordField.text == "1234" ){
            performSegue(withIdentifier: "login", sender: Any?.self)
        }
        else{
            let alert = UIAlertController(title: "Login Unsucessful", message: "Wrong Username/Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            
            self.present(alert, animated:true)
        }
        
    }
    
    func setup(){
        loginButton.layer.cornerRadius = 8
        
        usernameField.layer.cornerRadius = 8
        usernameField.backgroundColor = grayColor
        usernameField.setLeftPaddingPoints(15)
        
        passwordField.layer.cornerRadius = 8
        passwordField.backgroundColor = grayColor
        passwordField.setLeftPaddingPoints(15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController
        {
            let vc = segue.destination as? HomeViewController
            vc?.username = username
        }
    }

}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
