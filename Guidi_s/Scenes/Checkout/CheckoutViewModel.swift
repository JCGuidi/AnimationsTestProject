//
//  ChackoutViewModel.swift
//  Guidi_s
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
    var onOrderSuccess: (() -> Void)? = nil
    
    private let paymentMethods = [
        PaymentInformation(information: "Cash is cash."),
        PaymentInformation(information: "5% Off paying with this method. \n#StayHome", discount: 0.05),
        PaymentInformation(information: "Order again tomorrow to get a 10% Off with this payment method."),
        PaymentInformation(),
    ]
    
    init(cart: Cart = Cart.shared) {
        self.cart = cart
        orderList = "• " + cart.orders.joined(separator: "\n• ")
    }
    
    func handleOrderNowTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.onOrderSuccess?()
        }
    }
    
    func handleDismissTap() {
        coordinator?.dismiss()
    }
    
    func handleRestartTap() {
        cart.empty()
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
