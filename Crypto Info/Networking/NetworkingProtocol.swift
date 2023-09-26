//
//  NetworkingPrototype.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 18/09/23.
//

import Foundation
import Moya

public protocol NetworkingProtocal: TargetType {
    var parameters: [String : Any] { get }
}

extension NetworkingProtocal {
    public var baseURL: URL {
        return URL(string: Constants.baseUrl)!
    }
    
    var sampleData: Data {
        let json = ""
        return json.data(using: String.Encoding.utf8) ?? Data()
    }
    
    var parameters: [String : Any] { return [:] }
    
    var headers: [String : String]? {
        return [:]
    }
}
