//
//  MainViewController.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 21/09/23.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var tabsStackView: UIStackView!
    @IBOutlet weak var horizontalScroll: HorizontalScrollView!
    private var selectedTab = -1
    
    lazy var viewPages = [
        getPageView(type: .allCrypto),
        getPageView(type: .topGainer),
        getPageView(type: .topLosers)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.marketOverview
        navigationController?.navigationBar.prefersLargeTitles = true
        configScrollView()
        configTabs()
    }
    
    private func configTabs(){
        tabsStackView.axis = .horizontal
        tabsStackView.alignment = .center
        tabsStackView.distribution = .fillEqually
        tabsStackView.addArrangedSubview(self.getViewButtonTab(type: .allCrypto))
        tabsStackView.addArrangedSubview(self.getViewButtonTab(type: .topGainer))
        tabsStackView.addArrangedSubview(self.getViewButtonTab(type: .topLosers))
        selectTab(at: 0)
    }
    
    private func getViewButtonTab(type: ViewControllerTypeEnum) -> UIButton {
        let button = TabButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        switch(type){
        case .allCrypto:
            button.setTitle(L10n.allCrypto, for: .normal)
        case .topGainer:
            button.setTitle(L10n.topGainers, for: .normal)
        case .topLosers:
            button.setTitle(L10n.topLosers, for: .normal)
        }
        return button
    }
    
    @objc func buttonTapped(_ sender: TabButton) {
        for index in 0..<tabsStackView.subviews.count {
            if let button = tabsStackView.subviews[index] as? TabButton {
                if button == sender {
                    button.isSelected = true
                    let xOffset = horizontalScroll.frame.size.width * CGFloat(index)
                    horizontalScroll.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
                } else {
                    button.isSelected = false
                }
            }
        }
    }
    
    
    private func getPageView(type: ViewControllerTypeEnum) -> UIView {
        let pageView = CoinListUIView(frame: CGRect())
        pageView.setViewControllerType(type: type)
        pageView.setupView()
        pageView.didTableViewCellClicked = { coin in
            self.showCoinDetail(coinDetail: coin)
        }
        return pageView
    }
    
    func addTopLine() {
        let lineView = UIView(frame: CGRect(
            x: 0, y: 0, width: view.frame.width * CGFloat(viewPages.count), height: 2
        ))
        lineView.backgroundColor = Asset.Colors.colorLightGrey.color
        horizontalScroll.addSubview(lineView)
    }

    private func configScrollView(){
        horizontalScroll.showsHorizontalScrollIndicator = false
        horizontalScroll.showsVerticalScrollIndicator = false
        horizontalScroll.isPagingEnabled = true
        horizontalScroll.contentSize = CGSize(
            width: horizontalScroll.frame.width * CGFloat(viewPages.count),
            height: horizontalScroll.frame.height
        )
        horizontalScroll.delegate = self
        
        for index in 0..<viewPages.count {
            horizontalScroll.addSubview(viewPages[index])
            viewPages[index].frame = CGRect(
                x: view.frame.width * CGFloat(index),
                y: 0, width: view.frame.width,
                height: horizontalScroll.frame.height
            )
        }
        addTopLine()
    }
    
    private func selectTab(at postion: Int){
        if tabsStackView.subviews.count >= postion && selectedTab != postion {
            (tabsStackView.subviews[postion] as? TabButton)?.sendActions(for: .touchUpInside)
            selectedTab = postion
        }
    }
    
    private func showCoinDetail(coinDetail: CurrencyData){
        let vc = CoinDetailViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.setCoinDetail(coin: coinDetail)
        self.present(vc, animated: false)
    }

    
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.selectTab(at: currentPage)
    }
}
