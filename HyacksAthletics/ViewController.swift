//
//  ViewController.swift
//  HyacksAthletics
//
//  Created by Selena Liu on 2018-03-26.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let menuViewController = MenuController()
    let cellIDOne = "cell1"
    let cellIDTwo = "cell2"
    
    let titleLabelOne: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 1, green: 0.8196, blue: 0.5686, alpha: 1)
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = false
        textView.text = "This week's lifts"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let tableViewOne: UITableView = {
        let tv = UITableView()
        tv.separatorInset = .zero
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let titleLabelTwo: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(red: 1, green: 0.8196, blue: 0.5686, alpha: 1)
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = false
        textView.text = "Your last recorded weights"
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let tableViewTwo: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorInset = .zero
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let containerViewOne: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 1, green: 0.8196, blue: 0.5686, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let containerViewTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 1, green: 0.8196, blue: 0.5686, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let subOneOne: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor(red: 1, green: 0.9451, blue: 0.8196, alpha: 1.0)
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "N"
        return textView
    }()
    
    let subOneTwo: UITextView = {
        let textView = UITextView()
        textView.text = "Sets"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        return textView
    }()
    
    let subOneThree: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "Reps"
        return textView
    }()
    
    let subTwoOne: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "Name"
        return textView
    }()
    
    let subTwoTwo: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "Sets"
        return textView
    }()
    
    let subTwoThree: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "Reps"
        return textView
    }()
    
    let subTwoFour: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        textView.text = "Weight"
        return textView
    }()
    
    let subLabelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let subLabelViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 1, green: 0.9451, blue: 0.8196, alpha: 1.0)
        return view
    }()
    
    let subLabelViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 1, green: 0.9451, blue: 0.8196, alpha: 1.0)
        return view
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()

        view.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handleMenu)))
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ViewController.handleLogout))
        let menuButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(ViewController.handleMenu))
        
        self.navigationItem.rightBarButtonItem = logoutButton
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.title = "Name"
        
        
        addSubviews()
        
        tableViewOne.register(ChartCell.self, forCellReuseIdentifier: cellIDOne)
        tableViewTwo.register(ChartCell.self, forCellReuseIdentifier: cellIDTwo)

        tableViewOne.delegate = self
        tableViewTwo.delegate = self
        tableViewOne.dataSource = self
        tableViewTwo.dataSource = self
        
        setup()
    }
    
    
    @objc func handleMenu() {
        menuViewController.showMenu()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(ViewController.handleLogout), with: nil, afterDelay: 0)
        } else {
            let user = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(user!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:AnyObject] {
                    self.navigationItem.title = dictionary["name"] as? String
                    print("MainVC: name = \(dictionary["name"])")
                }
            }, withCancel: nil)
        }
    }
    
    @objc func handleLogout() {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "loginVC")
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        self.present(vc, animated: true, completion: nil)
        print("MainVC: logging out")

    }
    
    //TABLEVIEW STUBS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewOne {
            let cell = tableViewOne.dequeueReusableCell(withIdentifier: cellIDOne, for: indexPath) as! ChartCell
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsets.zero

            return cell
        } else {
            let cell = tableViewTwo.dequeueReusableCell(withIdentifier: cellIDTwo, for: indexPath) as! ChartCell
            cell.preservesSuperviewLayoutMargins = false
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }

    }
    
    func addSubviews() {
        view.addSubview(containerViewOne)
        view.addSubview(containerViewTwo)
        
        containerViewOne.addSubview(titleLabelOne)
        //containerViewOne.addSubview(subLabelViewOne)
        containerViewOne.addSubview(tableViewOne)
        containerViewTwo.addSubview(titleLabelTwo)
        containerViewTwo.addSubview(subLabelViewTwo)
        containerViewTwo.addSubview(tableViewTwo)
        
        containerViewOne.addSubview(subOneOne)
        containerViewOne.addSubview(subOneTwo)
        containerViewOne.addSubview(subOneThree)
        
//        subLabelViewTwo.addSubview(subTwoOne)
//        subLabelViewTwo.addSubview(subTwoTwo)
//        subLabelViewTwo.addSubview(subTwoThree)
//        subLabelViewTwo.addSubview(subTwoFour)
        
    }
    
    
    func setup() {
        [
            
            containerViewOne.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            containerViewOne.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            containerViewOne.heightAnchor.constraint(equalToConstant: 270),
            containerViewOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerViewTwo.topAnchor.constraint(equalTo: containerViewOne.bottomAnchor, constant: 30),
            containerViewTwo.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8),
            containerViewTwo.heightAnchor.constraint(equalToConstant: 271),
            containerViewTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            titleLabelOne.topAnchor.constraint(equalTo: containerViewOne.topAnchor),
            titleLabelOne.leftAnchor.constraint(equalTo: containerViewOne.leftAnchor),
            titleLabelOne.widthAnchor.constraint(equalTo: containerViewOne.widthAnchor),
            titleLabelOne.heightAnchor.constraint(equalToConstant: 35),
            
            titleLabelTwo.topAnchor.constraint(equalTo: containerViewTwo.topAnchor),
            titleLabelTwo.leftAnchor.constraint(equalTo: containerViewTwo.leftAnchor),
            titleLabelTwo.widthAnchor.constraint(equalTo: containerViewTwo.widthAnchor),
            titleLabelTwo.heightAnchor.constraint(equalToConstant: 36),

            
//            subLabelViewOne.topAnchor.constraint(equalTo: titleLabelOne.bottomAnchor),
//            subLabelViewOne.widthAnchor.constraint(equalTo: containerViewOne.widthAnchor),
//            subLabelViewOne.heightAnchor.constraint(equalToConstant: 40),
//            subLabelViewOne.leftAnchor.constraint(equalTo: containerViewOne.leftAnchor),

            subLabelViewTwo.topAnchor.constraint(equalTo: titleLabelTwo.bottomAnchor),
            subLabelViewTwo.widthAnchor.constraint(equalTo: containerViewTwo.widthAnchor),
            subLabelViewTwo.heightAnchor.constraint(equalToConstant: 40),
            subLabelViewTwo.leftAnchor.constraint(equalTo: containerViewTwo.leftAnchor),
            
            
            subOneOne.leftAnchor.constraint(equalTo: titleLabelOne.leftAnchor),
            subOneOne.widthAnchor.constraint(equalToConstant: titleLabelOne.bounds.width),
            subOneOne.heightAnchor.constraint(equalToConstant: 50),
            subOneOne.topAnchor.constraint(equalTo: titleLabelOne.bottomAnchor),
            
            subOneTwo.centerXAnchor.constraint(equalTo: titleLabelOne.centerXAnchor),
            subOneTwo.widthAnchor.constraint(equalToConstant: titleLabelOne.bounds.width/3),
            subOneTwo.heightAnchor.constraint(equalToConstant: 50),
            subOneTwo.topAnchor.constraint(equalTo: titleLabelOne.bottomAnchor),
            
            subOneThree.rightAnchor.constraint(equalTo: titleLabelOne.rightAnchor),
            subOneThree.widthAnchor.constraint(equalToConstant: titleLabelOne.bounds.width/3),
            subOneThree.heightAnchor.constraint(equalToConstant: 50),
            subOneThree.topAnchor.constraint(equalTo: titleLabelOne.bottomAnchor),
            
//            subTwoOne.leftAnchor.constraint(equalTo: subLabelViewTwo.leftAnchor),
//            subTwoOne.widthAnchor.constraint(equalToConstant: subLabelViewTwo.bounds.width/4),
//            subTwoOne.heightAnchor.constraint(equalTo: subLabelViewTwo.heightAnchor),
//            subTwoOne.topAnchor.constraint(equalTo: subLabelViewTwo.topAnchor),
//
//            subTwoTwo.leftAnchor.constraint(equalTo: subTwoOne.rightAnchor),
//            subTwoTwo.widthAnchor.constraint(equalToConstant: subLabelViewTwo.bounds.width/4),
//            subTwoTwo.heightAnchor.constraint(equalTo: subLabelViewTwo.heightAnchor),
//            subTwoTwo.topAnchor.constraint(equalTo: subLabelViewTwo.topAnchor),
//
//            subTwoThree.leftAnchor.constraint(equalTo: subTwoTwo.rightAnchor),
//            subTwoThree.widthAnchor.constraint(equalToConstant: subLabelViewTwo.bounds.width/4),
//            subTwoThree.heightAnchor.constraint(equalTo: subLabelViewTwo.heightAnchor),
//            subTwoThree.topAnchor.constraint(equalTo: subLabelViewTwo.topAnchor),
//
//            subTwoFour.leftAnchor.constraint(equalTo: subTwoThree.rightAnchor),
//            subTwoFour.widthAnchor.constraint(equalToConstant: subLabelViewTwo.bounds.width/4),
//            subTwoFour.heightAnchor.constraint(equalTo: subLabelViewTwo.heightAnchor),
//            subTwoFour.topAnchor.constraint(equalTo: subLabelViewTwo.topAnchor),
//
            
            
            tableViewOne.widthAnchor.constraint(equalTo: containerViewOne.widthAnchor),
            tableViewOne.heightAnchor.constraint(equalToConstant: 200),
            tableViewOne.topAnchor.constraint(equalTo: subOneOne.bottomAnchor),
            tableViewOne.leftAnchor.constraint(equalTo: containerViewOne.leftAnchor),
            
            tableViewTwo.widthAnchor.constraint(equalTo: containerViewTwo.widthAnchor),
            tableViewTwo.heightAnchor.constraint(equalToConstant: 200),
            tableViewTwo.topAnchor.constraint(equalTo: subLabelViewTwo.bottomAnchor),
            tableViewTwo.leftAnchor.constraint(equalTo: containerViewTwo.leftAnchor),
            
        ].forEach({$0.isActive = true})
        
        titleLabelOne.font = UIFont.systemFont(ofSize: view.bounds.width * 0.040)
        titleLabelTwo.font = UIFont.systemFont(ofSize: view.bounds.width * 0.040)
    }

    
}

class ChartCell: UITableViewCell {
    
}














