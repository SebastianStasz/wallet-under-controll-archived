//
//  EmptyWalletListView.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 22/05/2021.
//

import UIKit

class EmptyWalletListView: UIView {
   
   private let imageView = UIImageView()
   private let messageLabel = UILabel()
   var createWalletButton: UIButton!
   
   init() {
      super.init(frame: .zero)
      setupView()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- Setup View

extension EmptyWalletListView {
   
   private func setupView() {
      let imgSize = CGSize(width: 180, height: 180)
      imageView.image = UIImage(named: "wallet")?.scale(to: imgSize)
      imageView.contentMode = .scaleAspectFit
      
      messageLabel.text = "Don't allow your finances to get our of control before you start to manage them seriously. "
      messageLabel.font = .systemFont(ofSize: 18)
      messageLabel.textColor = .systemGray
      messageLabel.textAlignment = .center
      messageLabel.numberOfLines = 0
      
      createWalletButton = ViewComponents.mainButton(title: "Create Wallet")
      
      addSubview(imageView)
      addSubview(messageLabel)
      addSubview(createWalletButton)
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      imageView.translatesAutoresizingMaskIntoConstraints = false
      messageLabel.translatesAutoresizingMaskIntoConstraints = false
      createWalletButton.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
         imageView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -40),
         
         messageLabel.bottomAnchor.constraint(equalTo: createWalletButton.topAnchor, constant: -50),
         messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
         messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
         
         createWalletButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -250),
         createWalletButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
         createWalletButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
         createWalletButton.heightAnchor.constraint(equalToConstant: 50),
      ])
   }
}
