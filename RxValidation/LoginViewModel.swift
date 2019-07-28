//
//  ProfileModel.swift
//  RxValidation
//
//  Created by Mohsin on 28/07/19.
//  Copyright © 2019 Mohsin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    
    let userName: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
    let mobileNumber: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
    let mailId: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
    let password: BehaviorRelay<String?> = BehaviorRelay<String?>(value: "")
}


