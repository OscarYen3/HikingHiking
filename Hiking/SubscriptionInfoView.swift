//
//  SubscriptionInfoView.swift
//  Hiking
//
//  Created by Oscar Yen on 2022/7/13.
//  Copyright © 2022 OscarYen. All rights reserved.
//

import UIKit

protocol SubscriptionInfoDelegate {
    func SubscriptionInfoOk()
}

class SubscriptionInfoView: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    var _delegate: SubscriptionInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func BtnClick(_ sender: UIButton) {
        switch sender {
        case btnOk :
            _delegate?.SubscriptionInfoOk()
            break
            
        default:
            break
        }
        
    }

}
