//
//  CardOuselViewModel.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 18/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import Foundation

public struct CardOuselViewModel {
    var cardViewModels: [CardViewModel] = [
        CardViewModel(type: .cash, startColor: .cashStart, endColor: .cashEnd, textColor: .white),
        CardViewModel(type: .card(CardModel(name: "VISA", holder: "Card Holder", number: "1234 **** **** 4321")),
                      startColor: .visaStart,
                      endColor: .visaEnd,
                      textColor: .customBlack),
        CardViewModel(type: .card(CardModel(name: "Master Card", holder: "Master Name Surname", number: "1234 **** **** 4321")),
                      startColor: .masterStart,
                      endColor: .masterEnd,
                      textColor: .white),
        CardViewModel(type: .card(CardModel(name: "AMEX", holder: "Amex Name Surname", number: "1234 ****** 54321")),
                      startColor: .amexStart,
                      endColor: .amexEnd,
                      textColor: .customBlack)
    ]
    
    public init(viewModels: [CardViewModel]? = nil) {
        if let viewModels = viewModels {
            cardViewModels = viewModels
        }
    }
}
