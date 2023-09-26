//
//  HorizontalScrollView.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 21/09/23.
//

import UIKit

class HorizontalScrollView: UIScrollView {
    override var contentOffset: CGPoint {
        get {
            return super.contentOffset
        }
        set {
            super.contentOffset = CGPoint(x: newValue.x, y: 0)
        }
    }
}
