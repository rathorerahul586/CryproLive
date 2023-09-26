//
//  CrytoAPIManager.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 18/09/23.
//

import Foundation
import Moya
import Combine

class CryptoAPIManager {
    private let cryptoService = MoyaProvider<CryptoServiceAPI>()
    
    func fetchAllCoins(
        startingIndex: Int, itemsPerPage: Int
    ) -> AnyPublisher<CryptoListResponse, Error> {
        return Future<CryptoListResponse, Error> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            self.cryptoService.request(
                .cryptoList(limit: itemsPerPage, start: startingIndex)
            ){ result in
                switch result {
                case .success(let response):
                    do {
                        let cryptoResponse = try response.map(CryptoListResponse.self)
                        promise(.success(cryptoResponse))
                    } catch {
                        print("error \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                    promise(.failure(error))
                }
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchTopGainerLosersCoins(startingIndex: Int, itemsPerPage: Int, fetchGainers: Bool) -> AnyPublisher<CryptoListResponse, Error> {
        return Future<CryptoListResponse, Error> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            self.cryptoService.request(
                .gainersLosers(
                    limit: itemsPerPage,
                    start: startingIndex,
                    sortingOrder: fetchGainers ? "desc" : "asc"
                )
            ){ result in
                switch result {
                case .success(let response):
                    do {
                        let cryptoResponse = try response.map(CryptoListResponse.self)
                        promise(.success(cryptoResponse))
                    } catch {
                        print("error \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                    promise(.failure(error))
                }
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchChartDetail(id: Int, range: String) -> AnyPublisher<ChartAPIResponse, Error> {
        return Future<ChartAPIResponse, Error> { [weak self] promise in
            guard let self = self else {
                return
            }
            
            self.cryptoService.request(
                .chart(id: id, range: range)
            ){ result in
                switch result {
                case .success(let response):
                    do {
                        let cryptoResponse = try response.map(ChartAPIResponse.self)
                        promise(.success(cryptoResponse))
                    } catch {
                        print("error \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                case .failure(let error):
                    print("error \(error.localizedDescription)")
                    promise(.failure(error))
                }
                
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
}
