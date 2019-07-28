//
//  ValidationService.swift
//  RxValidation
//
//  Created by Mohsin on 28/07/19.
//  Copyright © 2019 Mohsin. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum ValidationResult {
    case ok
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return (true)
        case .failed(message: ""):
            return (false)
        default:
            return (false)
        }
    }
}

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case .ok:
            return ""
        case let .failed(message):
            return message
        }
    }
}

protocol ValidationService {
    
    func validateEmail(_ email: String) -> ValidationResult
    func validatePassword(_ password: String) -> ValidationResult
    func validateMobileNumber(_ mobileNumber:String) -> ValidationResult
    func validateUserName(_ userName:String) -> ValidationResult
}

extension ValidationService {
    func validateEmail(_ email: String) -> ValidationResult {
        if email.isEmpty {
            return .failed(message: "Email id can't be empty")
        } else if email.isValidEmail() {
            return .ok
        } else {
            return .failed(message: "Email id is inValid")
        }
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .failed(message: "Password can't be empty")
        } else if password.isValidPassword() {
            return .ok
        } else {
            return .failed(message: "Password should be more than 5 characters")
        }
    }
    
    func validateMobileNumber(_ mobileNumber: String) -> ValidationResult {
        if mobileNumber.isEmpty {
            return .failed(message: "Mobile number can't be empty")
        } else if mobileNumber.count >= 10 {
            return .ok
        } else {
            return .failed(message: "Mobile number is inValid")
        }
    }
    
    func validateUserName(_ userName: String) -> ValidationResult {
        if userName.isEmpty {
            return .failed(message: "Username can't be empty")
        }
        return .ok
    }
}

extension String {
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.count > 5 ? true : false
    }
}

protocol ValidationManager: ValidationService {
    var loginViewModel: LoginViewModel { get }
    var validatedUserName: Observable<ValidationResult> { get }
    var validatedMobileNumber: Observable<ValidationResult> { get }
    var validatedPassword: Observable<ValidationResult> { get }
    var validatedEmailId: Observable<ValidationResult> { get }
    var signUpValid: Observable<Bool> { get }
}

extension ValidationManager {
    
    var validatedUserName: Observable<ValidationResult> {
        return self.loginViewModel.userName.flatMapLatest({ (text) in
            return Observable.just(self.validateUserName(text ?? ""))
        })
    }
    
    var validatedPassword: Observable<ValidationResult> {
        return self.loginViewModel.password.flatMapLatest({ (text) in
            return Observable.just(self.validatePassword(text ?? ""))
        })
    }
    
    var validatedEmailId: Observable<ValidationResult> {
        return self.loginViewModel.mailId.flatMapLatest({ (text) in
            return Observable.just(self.validateEmail(text ?? ""))
        })
    }
    
    var validatedMobileNumber: Observable<ValidationResult> {
        return self.loginViewModel.mobileNumber.flatMapLatest({ (text) in
            return Observable.just(self.validateMobileNumber(text ?? ""))
        })
    }
    
    var signUpValid: Observable<Bool> {
        return Observable.combineLatest(validatedUserName, validatedEmailId, validatedMobileNumber, validatedPassword) {
            return $0.isValid && $1.isValid && $2.isValid && $3.isValid
        }
    }
    
    var showAlert: Observable<String> {
        return Observable.combineLatest(validatedUserName, validatedEmailId, validatedMobileNumber, validatedPassword)
            .flatMapLatest({ (a, b, c, d) -> Observable<String> in
                var alertMsg = ""
                if !a.description.isEmpty {
                    alertMsg = a.description
                } else if !b.description.isEmpty {
                    alertMsg = b.description
                } else if !c.description.isEmpty {
                    alertMsg = c.description
                } else if !d.description.isEmpty {
                    alertMsg = d.description
                }
                return .just(alertMsg)
            })
    }
}

