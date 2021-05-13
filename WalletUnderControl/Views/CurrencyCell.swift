//
//  CurrencyCell.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 09/05/2021.
//

import UIKit

class CurrencyCell: UITableViewCell {
   static let id = "CurrencyCell"
   static let height: CGFloat = 45
   
   private var cellHorizontalStack: UIStackView!
   
   private let currencyCodeLabel = UILabel()
   private let currencyNameLabel = UILabel()
   
   func configure(with currency: CurrencyEntity, isSelected: Bool = false) {
      currencyCodeLabel.text = currency.code
      currencyNameLabel.text = currency.name
      
      if isSelected { accessoryType = .checkmark }
   }
   
   private func setupViews() {
      // Currency Code Label
      currencyCodeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      currencyCodeLabel.font = .monospacedSystemFont(ofSize: 20, weight: .semibold)
      currencyCodeLabel.tintColor = FontManager.Color.main
      
      // Currency Name Label
      currencyNameLabel.tintColor = FontManager.Color.main
      
      cellHorizontalStack = UIStackView(arrangedSubviews: [currencyCodeLabel, currencyNameLabel])
      cellHorizontalStack.axis = .horizontal
      cellHorizontalStack.spacing = 30
      
      addSubview(cellHorizontalStack)
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      cellHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         cellHorizontalStack.topAnchor.constraint(equalTo: topAnchor),
         cellHorizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
         cellHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         cellHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      ])
   }
   
   override func prepareForReuse() {
      currencyCodeLabel.text = nil
      currencyNameLabel.text = nil
      accessoryType = .none
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
