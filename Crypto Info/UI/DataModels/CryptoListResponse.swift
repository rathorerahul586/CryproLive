//
//  CryptoListResponse.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 18/09/23.
//

import Foundation

struct CryptoListResponse: Codable {
    let code: String?
    let message, messageDetail: String?
    let data: ListData?
    let success: Bool?
}

struct ListData: Codable {
    let body: DataBody?
    let success: Bool?
}

struct DataBody: Codable {
    let data: [CurrencyData]?
}

struct CurrencyData: Codable {
    let id, numMarketPairs, cmcRank: Int?
    let name, symbol, slug, dateAdded, lastUpdated: String?
    let tags: [String]
    let maxSupply, circulatingSupply, totalSupply: Double?
    let infiniteSupply: Bool?
    let quote: Quote?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug, tags, quote
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case infiniteSupply = "infinite_supply"
        case cmcRank = "cmc_rank"
        case lastUpdated = "last_updated"
    }
    
    func getCoinIconUrl() -> String {
        "\(Constants.baseImageUrl)\(id ?? 0).png"
    }
}

struct Quote: Codable {
    let usd: USD?
    private enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct USD: Codable {
    let price, volume24H, volumeChange24H,
        percentChange1H, percentChange24H,
        percentChange7D, percentChange30D,
        percentChange60D, percentChange90D,
        marketCap, marketCapDominance, fullyDilutedMarketCap: Double?
    let lastUpdated: String?
    
    private enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case lastUpdated = "last_updated"
    }
}
