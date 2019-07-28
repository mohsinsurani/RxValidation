//
//  Rx+Extension.swift
//  RxValidation
//
//  Created by Mohsin on 28/07/19.
//  Copyright © 2019 Mohsin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

@discardableResult func <-><T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)
    
    let propertyToVariable = property
        .subscribe(
            onNext: {variable.accept($0)},
            onCompleted: { variableToProperty.dispose() }
    )
    
    return Disposables.create(variableToProperty, propertyToVariable)
}

