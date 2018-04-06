//
//  LoginVC.swift
//  HyacksAthletics
//
//  Created by Selena Liu on 2018-03-26.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    let hyacksLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hyacksIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginRegisterSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = UIColor(red: 0.9176, green: 0.4471, blue: 0.1098, alpha: 1.0)
        segment.insertSegment(withTitle: "Login", at: 0, animated: true)
        segment.insertSegment(withTitle: "Register", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(LoginVC.handleTextFieldContainer), for: .valueChanged)
        segment.selectedSegmentIndex = 1
        return segment
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First Name"
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let juniorSeniorSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .orange
        segment.insertSegment(withTitle: "Junior", at: 0, animated: true)
        segment.insertSegment(withTitle: "Senior", at: 1, animated: true)
        segment.layer.cornerRadius = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    let textFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.orange.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(LoginVC.handleLoginRegister), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(hyacksLogo)
        view.addSubview(loginRegisterSegment)
        view.addSubview(textFieldView)
        view.addSubview(loginRegisterButton)
        
        textFieldView.addSubview(nameTextField)
        textFieldView.addSubview(emailTextField)
        textFieldView.addSubview(passwordTextField)
        textFieldView.addSubview(juniorSeniorSegment)
        
        
        setup()
    }

    @objc func handleLoginRegister() {
        if loginRegisterSegment.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let grade = juniorSeniorSegment.titleForSegment(at: juniorSeniorSegment.selectedSegmentIndex) else {
            print("Form is invalid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // successfully authenticated User
            guard let uid = user?.uid else {
                return
            }
            
            let values = ["name": name, "email": email, "grade": grade]
            self.registerUserIntoDatabaseUsingUID(uid: uid, values: values)
        }
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is invalid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    private func registerUserIntoDatabaseUsingUID(uid: String, values: [String:Any]) {
        let ref = Database.database().reference(fromURL: "https://hyacks-athletics.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            // successfully saved user into Firebase Database
            
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTextFieldContainer() {
        let title = loginRegisterSegment.titleForSegment(at: loginRegisterSegment.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        textFieldViewHieightAnchor?.constant = loginRegisterSegment.selectedSegmentIndex == 0 ? 80 : 160
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: textFieldView.heightAnchor, multiplier: loginRegisterSegment.selectedSegmentIndex == 0 ? 0 : 1/4)
        nameTextFieldHeightAnchor?.isActive = true
    }
    
    var textFieldViewHieightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setup() {
        
        
        [
            hyacksLogo.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
            hyacksLogo.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
            hyacksLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            hyacksLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loginRegisterSegment.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            loginRegisterSegment.heightAnchor.constraint(equalToConstant: 35),
            loginRegisterSegment.topAnchor.constraint(equalTo: hyacksLogo.bottomAnchor),
            loginRegisterSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textFieldView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.topAnchor.constraint(equalTo: loginRegisterSegment.bottomAnchor, constant: 10),
            
            nameTextField.widthAnchor.constraint(equalTo: textFieldView.widthAnchor),
            nameTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            nameTextField.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: 12),
            
            emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor),
            emailTextField.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: 12),

            passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: textFieldView.leftAnchor, constant: 12),
            
            juniorSeniorSegment.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            juniorSeniorSegment.heightAnchor.constraint(equalToConstant: 40),
            juniorSeniorSegment.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            juniorSeniorSegment.leftAnchor.constraint(equalTo: textFieldView.leftAnchor),
            
            loginRegisterButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 35),
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 10)
            
        ].forEach({$0.isActive = true})
        
        textFieldViewHieightAnchor = textFieldView.heightAnchor.constraint(equalToConstant: 40 * 4)
        textFieldViewHieightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 40)
        nameTextFieldHeightAnchor?.isActive = true


    }

}

















