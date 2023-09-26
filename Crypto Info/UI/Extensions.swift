//
//  Extensions.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 19/09/23.
//

import Foundation
import UIKit
import SkeletonView
import Kingfisher

extension UIImageView {
    
    func setImageFromStringrURL(stringUrl: String?) {
        // show animation only when image is setting first time
        // to avoid blink effect when table cell is reloaded
        if self.image == nil {
            self.isSkeletonable = true
            self.showSkeltonAnimation()
        }
        
        if let strUrl = stringUrl, !strUrl.isEmpty {
            let url = URL(string: strUrl)
            self.kf.setImage(
                with: url,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            { result in
                switch result {
                case .failure:
                    print("Image Set Failure")
                case .success(_):
                    print("Image Set Successfullly")
                    
                }
                self.hideSkeleton()
            }
        }
        else {
            self.hideSkeleton()
        }
    }
    
}

extension UIView {
    func showSkeltonAnimation(){
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(
            withDirection: .leftRight
        )
        self.showAnimatedGradientSkeleton(animation: animation)
    }
}

extension Double {
    func formatPrice() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return numberFormatter.string(from: self as NSNumber) ?? ""
    }
    
    func formatPercentageValue() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "en_US")
        
        return "\(numberFormatter.string(from: self as NSNumber)!)%"
    }
    
    func formatDateFromMilliseconds() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, h:mm a"
        let date = Date(timeIntervalSince1970: self)
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}
