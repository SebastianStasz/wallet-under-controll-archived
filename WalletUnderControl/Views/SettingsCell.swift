//
//  SettingsCell.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import UIKit

class SettingsCell: UITableViewCell {
   static let id = "SettingsCell"
   static let height: CGFloat = 40
   
   private var cellHorizontalStack: UIStackView!
   
   private let nameLabel = UILabel()
   private let valueLabel = UILabel()
   
   func configure(with option: SettingsOption) {
      nameLabel.text = option.title
      valueLabel.text = option.value
      
      accessoryType = .disclosureIndicator
   }
   
   private func setupViews() {
      // Option Name Label
      //      nameLabel.font = .systemFont(ofSize: 18)
      
      cellHorizontalStack = UIStackView(arrangedSubviews: [nameLabel, valueLabel])
      cellHorizontalStack.distribution = .equalSpacing
      cellHorizontalStack.axis = .horizontal
      
      addSubview(cellHorizontalStack)
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      cellHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         cellHorizontalStack.topAnchor.constraint(equalTo: topAnchor),
         cellHorizontalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
         cellHorizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         cellHorizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
      ])
   }
   
   override func prepareForReuse() {
      nameLabel.text = nil
      valueLabel.text = nil
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
