//
//  CryptoViewModel.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 18/09/23.
//

import Foundation
import Moya
import Combine

class CryptoViewModel: ObservableObject {
    
    private var apiManager = CryptoAPIManager()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var coins: [CurrencyData] = []
    @Published var isLoading: Bool = true
    
    /// pagiantion
    var startingIndex = 1
    let itemPerPage = 20
    var hasMoreData = true
    
    func fetchCurrencyList(vcType: ViewControllerTypeEnum) {
        isLoading = true
        startingIndex = coins.endIndex + 1
        
        var request: AnyPublisher<CryptoListResponse, Error>
        switch(vcType){
        case .allCrypto:
            request = apiManager.fetchAllCoins(
                startingIndex: startingIndex,
                itemsPerPage: itemPerPage
            )
        case .topGainer:
            request = apiManager.fetchTopGainerLosersCoins(
                startingIndex: startingIndex,
                itemsPerPage: itemPerPage,
                fetchGainers: true
            )
        case .topLosers:
            request = apiManager.fetchTopGainerLosersCoins(
                startingIndex: startingIndex,
                itemsPerPage: itemPerPage,
                fetchGainers: false
            )
        }
        
        request.receive(on: DispatchQueue.global(qos: .background))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("API Request Error: \(error)")
                }
                self?.cancellables.removeAll()
            }, receiveValue: { [weak self] data in
                
                if let this = self {
                    data.data?.body?.data?.forEach { coin in
                        this.coins.append(coin)
                    }
                    this.isLoading = false
                    this.hasMoreData = this.coins.count >= this.itemPerPage
                    
                }
                
            })
            .store(in: &cancellables)
    }
    
    func resetPaginationData(){
        startingIndex = 1
        hasMoreData = true
        coins.removeAll()
    }

}
