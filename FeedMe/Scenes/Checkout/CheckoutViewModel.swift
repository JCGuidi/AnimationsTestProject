//
//  ChackoutViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

struct PaymentMethod {
    let name: String
    let description: String
    let informationTitle: String
    let information: String
    let startColor: UIColor
    let endColor: UIColor
    let textColor: UIColor
}

final class CheckoutViewModel {
    var coordinator: MainViewCoordinator?
    
    let paymentMethods = [
        PaymentMethod(name: "Cash", description: "", informationTitle: "", information: "", startColor: .cashStart, endColor: .cashEnd, textColor: .white),
        PaymentMethod(name: "VISA", description: "1234 **** **** 4321", informationTitle: "Card Holder", information: "Name Surname", startColor: .visaStart, endColor: .visaEnd, textColor: .customBlack),
        PaymentMethod(name: "Master Card", description: "1234 **** **** 4321", informationTitle: "Card Holder", information: "Master Name Surname", startColor: .masterStart, endColor: .masterEnd, textColor: .white),
        PaymentMethod(name: "AMEX", description: "1234 ****** 54321", informationTitle: "Card Holder", information: "Amex Name Surname", startColor: .amexStart, endColor: .amexEnd, textColor: .customBlack),
    ]
    
    func handleDismissTap() {
        coordinator?.dismiss()
    }
    
    init(cart: Cart = Cart.shared) {
        print(cart.orders)
    }
}
