//
//  CoinListUIView.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 21/09/23.
//

import UIKit
import Combine

class CoinListUIView: UIView {

    private var viewModel = CryptoViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var viewControllerType: ViewControllerTypeEnum = .allCrypto
    
    private let tableView = UITableView()
    private var activityIndicator: UIActivityIndicatorView!
    var didTableViewCellClicked: ((CurrencyData) -> ())? = nil
    
    func loadNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        guard
            let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last,
            let views = bundle.loadNibNamed(nibName, owner: self, options: nil),
            let contentView = views.first as? UIView
        else {
            return nil
        }

        return contentView
    }
        
    func setupView(){
        configTableView()
        viewModel.fetchCurrencyList(vcType: viewControllerType)
        observeCoinList()
    }
    
    private func configTableView(){
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(cellType: CurrencyTableViewCell.self)
        setLoadMoreProgressBar()
        setUIRefreshControl()
        print("hell0 - \(viewControllerType)")
    }

    
    private func setLoadMoreProgressBar(){
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(
            x: 0, y: 0, width: tableView.bounds.width, height: 44
        )
        tableView.tableFooterView = activityIndicator
    }
    
    private func setUIRefreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(
            self,
            action: #selector(callPullToRefresh),
            for: .valueChanged
        )
    }
    
    @objc func callPullToRefresh(){
        self.viewModel.resetPaginationData()
        self.viewModel.fetchCurrencyList(vcType: viewControllerType)
    }
    
    func setViewControllerType(type: ViewControllerTypeEnum){
        viewControllerType = type
        
        switch(type){
        case .allCrypto: backgroundColor = .red
        case .topGainer: backgroundColor = .blue
        case .topLosers: backgroundColor = .yellow
        }
    }
    
    private func observeCoinList() {
       viewModel.$coins
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                
                if let this = self {
                    this.activityIndicator.stopAnimating()
                    this.tableView.reloadData()
                    this.tableView.refreshControl?.endRefreshing()
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func loadMoreItems() {
        self.activityIndicator.startAnimating()
        viewModel.fetchCurrencyList(vcType: viewControllerType)
    }
    
    private func isLoading() -> Bool {
        return viewModel.isLoading && viewModel.coins.isEmpty
    }
}

extension CoinListUIView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading() ? 10 : viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CurrencyTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.showHideLoader(enableLoaing: isLoading())
        if !viewModel.coins.isEmpty {
            cell.setCard(coinInfo: viewModel.coins[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTableViewCellClicked?(viewModel.coins[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check if the user has scrolled to the bottom of the table view
        let contentHeight = tableView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.bounds.size.height
        
        if yOffset > contentHeight - scrollViewHeight {
            // Load more data if not already fetching data
            if self.viewModel.hasMoreData && !self.viewModel.isLoading {
                loadMoreItems()
            }
        }
    }
}
