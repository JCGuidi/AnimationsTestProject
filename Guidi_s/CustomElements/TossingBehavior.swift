//
//  TossingBehavior.swift
//  Guidi_s
//
//  Created by Juan Cruz Guidi on 25/07/2020.
//  Copyright © 2020 Juan Cruz Guidi. All rights reserved.
//

import UIKit

final class TossingBehavior: UIDynamicBehavior {
    private let snap: UISnapBehavior
    private let item: UIDynamicItem
    private var bounds: CGRect?
    
    var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                addChildBehavior(snap)
            } else {
                removeChildBehavior(snap)
            }
        }
    }
    
    init(item: UIDynamicItem, snapTo: CGPoint) {
        self.item = item
        self.snap = UISnapBehavior(item: item, snapTo: snapTo)
        super.init()
        addChildBehavior(snap)

    }
    
    // MARK: UIDynamicBehavior
    
    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        super.willMove(to: dynamicAnimator)
        bounds = dynamicAnimator?.referenceView?.bounds
    }
}
