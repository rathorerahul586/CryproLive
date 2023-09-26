//
//  ChartAPIResponse.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 22/09/23.
//

import Foundation

struct ChartAPIResponse: Codable {
    let code: String?
    let message: String?
    let messageDetail: String?
    let data: ResponseData?
    let success: Bool?
}

struct ResponseData: Codable {
    let body: BodyData?
    let success: Bool?
}

struct BodyData: Codable {
    let data: DataPoints?
}

struct DataPoints: Codable {
    let points: [String: DataPoint]?
}

struct DataPoint: Codable {
    let c: [Double]?
    let v: [Double]?
}
