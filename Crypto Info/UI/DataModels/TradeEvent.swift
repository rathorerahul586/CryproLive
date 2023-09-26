//
//  CoinLivePriceModel.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 25/09/23.
//

import Foundation

struct TradeEvent: Codable {
    let eventType: String? // "e"
    let eventTime: Int64? // "E"
    let symbol: String? // "s"
    let tradeId: Int64? // "t"
    let price: String? // "p"
    let quantity: String? // "q"
    let buyerOrderId: Int64? // "b"
    let sellerOrderId: Int64? // "a"
    let tradeTime: Int64? // "T"
    let isBuyerMarketMaker: Bool? // "m"
    let isBestPriceMatch: Bool? // "M"

    enum CodingKeys: String, CodingKey {
        case eventType = "e"
        case eventTime = "E"
        case symbol = "s"
        case tradeId = "t"
        case price = "p"
        case quantity = "q"
        case buyerOrderId = "b"
        case sellerOrderId = "a"
        case tradeTime = "T"
        case isBuyerMarketMaker = "m"
        case isBestPriceMatch = "M"
    }
}
