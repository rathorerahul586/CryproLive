//
//  CurrencyTableViewCell.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 19/09/23.
//

import UIKit
import Reusable
import SkeletonView

class CurrencyTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinCode: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinPriceChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configSkeltonLoadingView()
        configCard()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            backgroundColor = .clear
        }
    }
    
    func configCard(){
        cardView.layer.cornerRadius = 8
        cardView.backgroundColor = Asset.Colors.colorLightGrey.color
        
        coinName.font = .boldSystemFont(ofSize: 16)
        coinCode.font = .systemFont(ofSize: 12)
        coinPrice.font = .systemFont(ofSize: 16)
        coinPriceChange.font = .boldSystemFont(ofSize: 16)
    }
    
    func configSkeltonLoadingView(){
        [coinImage, coinName, coinCode, coinPrice, coinPriceChange].forEach { view in
            view?.isSkeletonable = true
        }
    }
    
    func showHideLoader(enableLoaing: Bool){
        [coinImage, coinName, coinCode, coinPrice, coinPriceChange].forEach { view in
            enableLoaing ? view.showSkeltonAnimation() : view.hideSkeleton()
        }
    }
    
    func setCard(coinInfo: CurrencyData){
        coinImage.setImageFromStringrURL(stringUrl: coinInfo.getCoinIconUrl())
        coinName.text = coinInfo.name
        coinCode.text = coinInfo.symbol
        coinPrice.text = coinInfo.quote?.usd?.price?.formatPrice()
        
        if coinInfo.quote?.usd?.percentChange24H ?? 0 > 0 {
            coinPriceChange.textColor = .greenSea
        } else {
            coinPriceChange.textColor = .red
        }
        coinPriceChange.text = coinInfo.quote?.usd?.percentChange24H?.formatPercentageValue()
        
    }
    
}
