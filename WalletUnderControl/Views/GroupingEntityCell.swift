//
//  GroupingEntityCell.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import UIKit

class GroupingEntityCell<T: GroupingEntity>: UITableViewCell {
   
   private let nameLabel = UILabel()
   
   func configure(with item: T, isSelected: Bool = false) {
      nameLabel.text = item.name
      if isSelected { accessoryType = .checkmark }
   }
   
   private func setupViews() {
      addSubview(nameLabel)
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      nameLabel.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         nameLabel.topAnchor.constraint(equalTo: topAnchor),
         nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
         nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      ])
   }
   
   override func prepareForReuse() {
      nameLabel.text = nil
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
