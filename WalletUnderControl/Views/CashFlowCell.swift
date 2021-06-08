//
//  CashFlowCell.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 08/06/2021.
//

import UIKit

class CashFlowCell: UITableViewCell {
   static let id = "CashFlowCell"
//   static let height: CGFloat = 65
   
   private let titleLabel = UILabel()
   private let dateLabel = UILabel()
   private let amountLabel = UILabel()
   
   func configure(cashFlow: CashFlowEntity) {
      titleLabel.text = cashFlow.name
      dateLabel.text = DateHelper.shared.string(from: cashFlow.date, format: .medium, time: false)
      let isIncome = cashFlow.category.type == .income
      amountLabel.text = "\(isIncome ? "+" : "-") \(cashFlow.value)"
      amountLabel.textColor = isIncome ? .systemGreen : .systemRed
   }
   
   private func setupViews() {
      
      // Title Label
      titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
//      titleLabel.textColor = FontManager.Color.main
      
      // Date Label
      dateLabel.font = .systemFont(ofSize: 15)
   
      
      let leftStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
      leftStackView.distribution = .equalSpacing
      leftStackView.spacing = 6
      leftStackView.axis = .vertical
      
      let cellStackView = UIStackView(arrangedSubviews: [leftStackView, amountLabel])
      cellStackView.distribution = .equalSpacing
      cellStackView.axis = .horizontal
      
      layer.cornerRadius = 15
      clipsToBounds = true
      addSubview(cellStackView)
      
      // MARK: Setup Auto Layout
      
      cellStackView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         cellStackView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
         cellStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
         cellStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         cellStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      ])
   }

   override func prepareForReuse() {
      titleLabel.text = nil
      dateLabel.text = nil
      amountLabel.text = nil
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
