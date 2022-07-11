//
//  Double+Ex.swift
//  Hiking
//
//  Created by OscarYen on 2019/1/3.
//  Copyright © 2019 OscarYen. All rights reserved.
//



import Foundation

extension Double {
    func rounded(toDecimalPlace place:Int)->Double {
        let divisor = pow(10.0,Double(place))
        return (self * divisor).rounded()/divisor
    }
}
