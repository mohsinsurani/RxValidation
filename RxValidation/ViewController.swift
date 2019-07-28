//
//  ViewController.swift
//  RxValidation
//
//  Created by Mohsin on 26/07/19.
//  Copyright © 2019 Mohsin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, ValidationManager {
    internal var loginViewModel: LoginViewModel = LoginViewModel()
    
    @IBOutlet weak private var usernameTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var mobileNoTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async { [weak self] in
            _ = self?.view.subviews.first?.subviews.map({($0 as? UITextField)?.layer.addBorder(.gray)})
            self?.submitButton.layer.cornerRadius = 8
        }
        
        self.usernameTextField.rx.text <-> self.loginViewModel.userName
        self.emailTextField.rx.text <-> self.loginViewModel.mailId
        self.mobileNoTextField.rx.text <-> self.loginViewModel.mobileNumber
        self.passwordTextField.rx.text <-> self.loginViewModel.password
    
        self.signUpValid.subscribe(onNext: { [weak self] valid in
            self?.submitButton.alpha = valid ? 1.0 : 0.3
        }).disposed(by: self.disposeBag)
        
        self.submitButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(true)
            self?.showAlert.subscribe(onNext: { (alertMsg) in
                if alertMsg.isEmpty {
                    self?.showAlert("Success!", message: "Your Validations are successfull")
                } else {
                    self?.showAlert("Error!", message: alertMsg)
                }
            }).dispose()
        }).disposed(by: disposeBag)
    }
}

extension ViewController {
    func showAlert(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
