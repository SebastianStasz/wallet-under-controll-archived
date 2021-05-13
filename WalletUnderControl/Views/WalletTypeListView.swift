//
//  WalletTypeListView.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import UIKit

class WalletTypeListView: UIView {
   
   let walletTypesTBV = UITableView()
   let addTypeBTN = UIButton()
   
   init() {
      super.init(frame: .zero)
      setup()
   }
   
   private func setup() {
      walletTypesTBV.rowHeight = WalletTypeCell.height
      walletTypesTBV.register(WalletTypeCell.self, forCellReuseIdentifier: WalletTypeCell.id)
      
      addTypeBTN.setImage(UIImage(systemName: "plus"), for: .normal)
      addTypeBTN.imageView?.contentMode = .scaleAspectFit
      addTypeBTN.imageView?.clipsToBounds = true
      addTypeBTN.imageView?.tintColor = .black
      addTypeBTN.backgroundColor = .systemGreen
      
      addTypeBTN.layer.cornerRadius = 28
      addTypeBTN.layer.shadowRadius = 15
      addTypeBTN.layer.shadowOpacity = 0.2
      addTypeBTN.layer.masksToBounds = false
      addTypeBTN.layer.shadowColor = UIColor.label.cgColor
      addTypeBTN.layer.shadowOffset = CGSize(width: 0, height: 0)
      
      addSubview(walletTypesTBV)
      addSubview(addTypeBTN)
      
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      addTypeBTN.translatesAutoresizingMaskIntoConstraints = false
      addTypeBTN.imageView?.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         addTypeBTN.imageView!.widthAnchor.constraint(equalToConstant: 30),
         addTypeBTN.imageView!.heightAnchor.constraint(equalToConstant: 30),
         addTypeBTN.widthAnchor.constraint(equalToConstant: 56),
         addTypeBTN.heightAnchor.constraint(equalToConstant: 56),
         addTypeBTN.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
         addTypeBTN.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

