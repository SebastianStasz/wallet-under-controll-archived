//
//  WalletCell.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import UIKit

struct FontManager {
   
   struct Color {
      static let main = UIColor.secondaryLabel
   }
}

class WalletCell: UITableViewCell {
   static let id = "WalletCell"
   static let height: CGFloat = 80
   
   private var topStackView: UIStackView!
   private var verticalSV: UIStackView!
   
   private let walletIconIV = UIImageView()
   private let walletNameLabel = UILabel()
   private let walletTypeLabel = UILabel()
   private let walletBalanceLabel = UILabel()
   
   func configure(wallet: WalletEntity) {
      walletNameLabel.text = wallet.name
      walletTypeLabel.text = wallet.type.name
      walletIconIV.tintColor = wallet.iconColor.color
      walletIconIV.image = UIImage(systemName: wallet.icon.name)
      walletBalanceLabel.attributedText = getBalanceText(for: wallet)
   }
   
   private func setupViews() {
      
      // Wallet Name Label
      walletNameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
      walletNameLabel.tintColor = FontManager.Color.main
      
      // Wallet Type Label
      walletTypeLabel.font = .systemFont(ofSize: 13, weight: .medium)
      
      // Wallet Balance Label
      walletBalanceLabel.font = .systemFont(ofSize: 16)
      
      // Wallet Icon Image View
      walletIconIV.contentMode = .scaleAspectFit
      
      topStackView = UIStackView(arrangedSubviews: [walletNameLabel, walletTypeLabel])
      topStackView.axis = .horizontal
      
      verticalSV = UIStackView(arrangedSubviews: [topStackView, walletBalanceLabel])
      verticalSV.distribution = .fillEqually
      verticalSV.axis = .vertical
      
      addSubview(walletIconIV)
      addSubview(verticalSV)
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      verticalSV.translatesAutoresizingMaskIntoConstraints = false
      walletIconIV.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         walletIconIV.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
         walletIconIV.topAnchor.constraint(equalTo: topAnchor),
         walletIconIV.bottomAnchor.constraint(equalTo: bottomAnchor),
         walletIconIV.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20),
         
         verticalSV.topAnchor.constraint(equalTo: topAnchor, constant: 7),
         verticalSV.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -7),
         verticalSV.leadingAnchor.constraint(equalTo: walletIconIV.trailingAnchor, constant: 20),
         verticalSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      ])
   }
   
   override func prepareForReuse() {
      walletNameLabel.text = nil
      walletTypeLabel.text = nil
      walletBalanceLabel.text = nil
      walletIconIV.image = nil
   }
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

extension WalletCell {
   
   private func getBalanceText(for wallet: WalletEntity) -> NSMutableAttributedString {
      let attr1 = [NSAttributedString.Key.foregroundColor : FontManager.Color.main]
      let attr2 = [NSAttributedString.Key.foregroundColor : UIColor.systemGreen]
      
      let balanceLabel = NSMutableAttributedString(string:"Balance: ", attributes: attr1)
      let balanceText = wallet.availableBalance.toCurrency(wallet.currency.code)
      
      balanceLabel.append(NSMutableAttributedString(string: balanceText, attributes: attr2))
      return balanceLabel
   }
}
