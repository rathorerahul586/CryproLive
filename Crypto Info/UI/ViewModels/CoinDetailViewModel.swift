//
//  CoinDetailViewModel.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 22/09/23.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    
    private var apiManager = CryptoAPIManager()
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var chartData: DataPoints?
    @Published var currentCoinPrice: String?
    
    private var webSocketManager: WebSocketManager?
    
    func startWebSocket(coinSymbol: String) {
        if let url = URL(
            string: "wss://stream.binance.com:9443/ws/\(coinSymbol.lowercased())usdt@trade"
        ) {
            webSocketManager = WebSocketManager(url: url)
            webSocketManager?.delegate = self
        }
    }
    
    func fetchChartData(coinId: Int, range: String) {
        apiManager.fetchChartDetail(id: coinId, range: range).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("API Request Error: \(error)")
                }
                self?.cancellables.removeAll()
            }, receiveValue: { [weak self] data in
                self?.chartData = data.data?.body?.data
            })
            .store(in: &cancellables)
    }
}

extension CoinDetailViewModel: WebSocketManagerDelegate {
    func didReceiveMessage(_ message: String) {
        if let jsonData = message.data(using: .utf8) {
            do {
                let trade = try JSONDecoder().decode(TradeEvent.self, from: jsonData)
                if let price = Double (trade.price ?? ""){
                    currentCoinPrice = price.formatPrice()
                }
            } catch {
                print("Error decoding WebSocket message: \(error)")
            }
        }
    }
}
