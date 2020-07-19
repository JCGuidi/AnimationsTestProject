//
//  ChackoutViewModel.swift
//  FeedMe
//
//  Created by Juan Cruz Guidi on 17/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

struct PaymentInformation {
    var title: String = "Total amount €"
    var information: String = ""
    var discount: Double = 0
}

final class CheckoutViewModel {
    private var cart: Cart
    private(set) var orderList: String
    
    var coordinator: MainViewCoordinator?
    
    private let paymentMethods = [
        PaymentInformation(information: "Cash is cash."),
        PaymentInformation(information: "5% Off paying with this method. \n#StayHome", discount: 0.05),
        PaymentInformation(),
        PaymentInformation(),
    ]
    
    init(cart: Cart = Cart.shared) {
        self.cart = cart
        orderList = "• " + cart.orders.joined(separator: "\n• ")
    }
    
    func handleDismissTap() {
        coordinator?.dismiss()
    }
    
    func handleRestartTap() {
        coordinator?.restart()
    }
    
    func getInformationFor(option: Int) -> (title: String, subtitle: String) {
        let current = paymentMethods[option]
        let totalAmount: Double = Double(cart.orders.count) * 10 * (1 - current.discount)
        let title = current.title + "\(totalAmount)"
        let subtitle = current.information
        return (title: title, subtitle: subtitle)
    }
}
