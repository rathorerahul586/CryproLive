//
//  CoinDetailViewController.swift
//  Crypto Info
//
//  Created by Rahul Kumar on 20/09/23.
//

import UIKit
import DGCharts
import Combine

class CoinDetailViewController: BottomSheetViewController {
    
    private let viewModel = CoinDetailViewModel()
    private var coinDetail: CurrencyData? = nil
    
    private let coinIcon = UIImageView()
    private let coinName = UILabel()
    private let coinPrice = UILabel()
    private let priceChangeStackView = UIStackView()
    private let percentageChange = UILabel()
    private var durationLabel = UILabel()
    private let chartView = LineChartView()
    private let timeIntervalStackView = UIStackView()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        maximumContainerHeight = 500
        setDefaulHeight(height: maximumContainerHeight)
        configCoinDetailBottomSheet()
        super.viewDidLoad()
    }

    func setCoinDetail(coin currencyData: CurrencyData) {
        coinDetail = currencyData
        viewModel.startWebSocket(coinSymbol: currencyData.symbol ?? "BTC")
        observeChartPoints()
    }
    
    private func configCoinDetailBottomSheet(){
        setCoinIcon()
        setCoinNameLabel()
        setCoinPriceLabel()
        setPriceChangeStackView()
        configChart()
        setTimeIntervals()
    }
    
    private func setCoinIcon(){
        coinIcon.translatesAutoresizingMaskIntoConstraints = false
        coinIcon.setImageFromStringrURL(stringUrl: coinDetail?.getCoinIconUrl())
        coinIcon.contentMode = .scaleAspectFit
        containerView.addSubview(coinIcon)
        
        NSLayoutConstraint.activate([
            coinIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            coinIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            coinIcon.widthAnchor.constraint(equalToConstant: 30),
            coinIcon.heightAnchor.constraint(equalToConstant: 30),
            
        ])
    }
    
    private func setCoinNameLabel(){
        coinName.translatesAutoresizingMaskIntoConstraints = false
        coinName.text = "\(coinDetail?.name ?? "") (\(coinDetail?.symbol ?? ""))"
        coinName.font = .boldSystemFont(ofSize: 16)
        containerView.addSubview(coinName)
        
        NSLayoutConstraint.activate([
            coinName.leadingAnchor.constraint(equalTo: coinIcon.trailingAnchor, constant: 16),
            coinName.centerYAnchor.constraint(equalTo: coinIcon.centerYAnchor)
        ])
    }
    
    private func setCoinPriceLabel(){
        viewModel.currentCoinPrice = coinDetail?.quote?.usd?.price?.formatPrice()
        coinPrice.translatesAutoresizingMaskIntoConstraints = false
        coinPrice.text = coinDetail?.quote?.usd?.price?.formatPrice()
        coinPrice.textAlignment = .center
        coinPrice.font = .systemFont(ofSize: 24)
        containerView.addSubview(coinPrice)
        
        NSLayoutConstraint.activate([
            coinPrice.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            coinPrice.topAnchor.constraint(equalTo: coinIcon.bottomAnchor, constant: 30)
        ])
        
        observeCoinCurrentPrice()
    }
    
    private func observeCoinCurrentPrice(){
        viewModel.$currentCoinPrice
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: coinPrice)
            .store(in: &cancellables)
    }
    
    private func setPriceChangeStackView(){
        let priceChangeLabel = UILabel()
        priceChangeLabel.text = coinDetail?.quote?.usd?.volumeChange24H?.formatPrice()
        priceChangeLabel.font = .systemFont(ofSize: 16)
        priceChangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        percentageChange.text = coinDetail?.quote?.usd?.percentChange24H?.formatPercentageValue()
        percentageChange.font = .systemFont(ofSize: 16)
        percentageChange.translatesAutoresizingMaskIntoConstraints = false
        
        if coinDetail?.quote?.usd?.percentChange24H ?? 0 > 0 {
            percentageChange.textColor = .greenSea
            priceChangeLabel.textColor = .greenSea
        } else {
            percentageChange.textColor = .red
            priceChangeLabel.textColor = .red
        }
        
        durationLabel.textColor = .gray
        durationLabel.font = .systemFont(ofSize: 16)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorView1 = createSeparator()
        let separatorView2 = createSeparator()
        
        priceChangeStackView.spacing = 8
        priceChangeStackView.addArrangedSubview(priceChangeLabel)
        priceChangeStackView.addArrangedSubview(separatorView1)
        priceChangeStackView.addArrangedSubview(percentageChange)
        priceChangeStackView.addArrangedSubview(separatorView2)
        priceChangeStackView.addArrangedSubview(durationLabel)
        containerView.addSubview(priceChangeStackView)
        
        priceChangeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceChangeStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            priceChangeStackView.topAnchor.constraint(equalTo: coinPrice.bottomAnchor, constant: 16)
        ])
    }
    
    private func createSeparator() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = Asset.Colors.separatorColor.color
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return separatorView
    }
    
    private func configChart(){
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.xAxis.granularity = 10.0
        chartView.xAxis.labelPosition = .bottom
        chartView.legend.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.highlightPerTapEnabled = true
        
        let marker = ChartMarker()
        marker.chartView = chartView
        chartView.marker = marker
        
        chartView.isSkeletonable = true
        
        containerView.addSubview(chartView)
        NSLayoutConstraint.activate([
            chartView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 200),
            chartView.topAnchor.constraint(equalTo: priceChangeStackView.bottomAnchor, constant: 20)
        ])
    }
    
    private func observeChartPoints() {
        viewModel.$chartData
            .receive(on: RunLoop.main)
            .sink { [weak self] points in
                self?.setChartData(points: points?.points)
            }
            .store(in: &cancellables)
    }
    
    private func setChartData(points: [String: DataPoint]?){
        if let sortedData = points?.sorted(by: { $0.key < $1.key }) {
            var dataEntries: [ChartDataEntry] = []
            for (key, value) in sortedData {
                if let x = Double(key), let y = value.v?.first {
                    let dataEntry = ChartDataEntry(x: x, y: y)
                    dataEntries.append(dataEntry)
                }
            }
            
            let dataSet = LineChartDataSet(entries: dataEntries, label: "")
            let data = LineChartData(dataSet: dataSet)
            chartView.data = data

            dataSet.colors = [NSUIColor.blue]
            dataSet.highlightColor = .blue
            dataSet.highlightEnabled = true
            dataSet.drawValuesEnabled = true
            dataSet.drawCirclesEnabled = false
            dataSet.drawHorizontalHighlightIndicatorEnabled = false
            dataSet.highlightLineDashLengths = [5]
            chartView.notifyDataSetChanged()
            chartView.hideSkeleton()
        }
    }
    
    private func setTimeIntervals(){
        let interval1D = createTimeIntervalLabel(text: L10n.oneD)
        let interval1W = createTimeIntervalLabel(text: L10n.sevenD)
        let interval1M = createTimeIntervalLabel(text: L10n.oneM)
        let interval1Y = createTimeIntervalLabel(text: L10n.oneY)
        
        timeIntervalStackView.spacing = 12
        timeIntervalStackView.addArrangedSubview(interval1D)
        timeIntervalStackView.addArrangedSubview(interval1W)
        timeIntervalStackView.addArrangedSubview(interval1M)
        timeIntervalStackView.addArrangedSubview(interval1Y)
        timeIntervalStackView.distribution = .equalSpacing
        containerView.addSubview(timeIntervalStackView)
        
        timeIntervalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeIntervalStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor, constant: 24
            ),
            timeIntervalStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -24
            ),
            timeIntervalStackView.topAnchor.constraint(
                equalTo: chartView.bottomAnchor, constant: 16
            )
        ])
        
        interval1D.sendActions(for: .touchUpInside)
    }
    
    private func createTimeIntervalLabel(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.blue, for: .selected)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleIntervalTap), for: .touchUpInside)
        return button
    }
    
    private func setInterval(interval: String){
        switch (ChartDataIntervalsEnum(rawValue: interval)) {
        case .dayOne:
            durationLabel.text = L10n.pastDuration(L10n.oneDay)
            percentageChange.text = coinDetail?.quote?.usd?.percentChange24H?.formatPercentageValue()
        case .daySeven:
            durationLabel.text = L10n.pastDuration(L10n.sevenDays)
            percentageChange.text = coinDetail?.quote?.usd?.percentChange7D?.formatPercentageValue()
        case .monthOne:
            durationLabel.text = L10n.pastDuration(L10n.oneMonth)
            percentageChange.text = coinDetail?.quote?.usd?.percentChange30D?.formatPercentageValue()
        case .yearOne:
            durationLabel.text = L10n.pastDuration(L10n.oneYear)
            percentageChange.text = coinDetail?.quote?.usd?.percentChange90D?.formatPercentageValue()
        case .none:
            durationLabel.text = L10n.pastDuration(L10n.oneDay)
            percentageChange.text = coinDetail?.quote?.usd?.percentChange24H?.formatPercentageValue()
        }
    }
    
    @objc func handleIntervalTap(_ sender: UIButton) {
        if let interval = sender.titleLabel?.text?.replacingOccurrences(of: " ", with: "") {
            chartView.showSkeltonAnimation()
            viewModel.fetchChartData(coinId: coinDetail?.id ?? 1, range: interval)
            setInterval(interval: interval)
        }
        
        timeIntervalStackView.subviews.forEach { subview in
            if let button = subview as? UIButton {
                if button == sender {
                    button.backgroundColor = .blue.withAlphaComponent(0.1)
                    button.isSelected = true
                } else {
                    button.backgroundColor = .clear
                    button.isSelected = false
                }
            }
        }
    }
}

class ChartMarker: MarkerView {
    private var text = String()

    private let drawAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.gray.cgColor,
        .backgroundColor: UIColor.clear
    ]

    override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        text = "\(entry.y.formatPrice()) ◦ \(entry.x.formatDateFromMilliseconds())"
    }

    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)

        let sizeForDrawing = text.size(withAttributes: drawAttributes)
        bounds.size = sizeForDrawing
        offset = CGPoint(x: -sizeForDrawing.width / 2, y: -sizeForDrawing.height - 4)

        let offset = offsetForDrawing(atPoint: point)
        let originPoint = CGPoint(x: point.x + offset.x, y: point.y + offset.y)
        let rectForText = CGRect(origin: originPoint, size: sizeForDrawing)
        drawText(text: text, rect: rectForText, withAttributes: drawAttributes)
    }

    private func drawText(text: String, rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]? = nil) {
        let size = bounds.size
        let centeredRect = CGRect(
            x: rect.origin.x + (rect.size.width - size.width) / 2,
            y: 0,
            width: size.width,
            height: size.height
        )
        text.draw(in: centeredRect, withAttributes: attributes)
    }
}

internal enum ChartDataIntervalsEnum: String {
    case dayOne = "1D"
    case daySeven = "7D"
    case monthOne = "1M"
    case yearOne = "1Y"
}
