//
//  CryptoService.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 18/09/23.
//

import Foundation
import Moya
import Combine

enum CryptoServiceAPI{
    case cryptoList(limit: Int, start: Int)
    case gainersLosers(limit: Int, start: Int, sortingOrder: String)
    case chart(id: Int, range: String)
}

extension CryptoServiceAPI: NetworkingProtocal {
    
    var path: String {
        switch self {
        case .cryptoList:
            return "listings/latest"
        case .gainersLosers:
            return "trending/gainers-losers"
        case .chart:
            return "detail/chart"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .cryptoList(let limit, let start):
            return .requestParameters(
                parameters: [
                    "limit": limit,
                    "start": start
                ],
                encoding: URLEncoding.queryString
            )
        case .gainersLosers(let limit, let start, let sortingOrder):
            return .requestParameters(
                parameters: [
                    "limit": limit,
                    "start": start,
                    "sort_dir": sortingOrder
                ],
                encoding: URLEncoding.queryString
            )
        case .chart(id: let id, range: let range):
            return .requestParameters(
                parameters: [
                    "id": id,
                    "range": range
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}
