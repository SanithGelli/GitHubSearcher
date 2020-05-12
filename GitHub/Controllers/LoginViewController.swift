//
//  LoginViewController.swift
//  GitHub
//
//  Created by Sanith on 5/5/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userID.delegate = self
        self.password.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userID.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func loginAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "searchVC") as! SearchViewController
        
        if (userID.text == "sanith.github" && password.text == "sanith") {
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            showToast(message: "Invalid \n For login Please enter \n User ID - 'sanith.github' \n Passowrd - 'sanith'")
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-390, width: 280, height: 100))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 10.0)
        toastLabel.textAlignment = .center
        toastLabel.numberOfLines = 10
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.7, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
