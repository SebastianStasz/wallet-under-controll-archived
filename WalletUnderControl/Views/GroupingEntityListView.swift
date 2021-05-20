//
//  GroupingEntityListView.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import UIKit

class GroupingEntityListView<T: GroupingEntity>: UIView {
   
   let tableView = UITableView()
   let addItemBTN = UIButton()
   
   init() {
      super.init(frame: .zero)
      setup()
   }
   
   private func setup() {
      tableView.rowHeight = 45
      tableView.register(GroupingEntityCell<T>.self, forCellReuseIdentifier: "GroupingEntityCell")
      
      addItemBTN.setImage(UIImage(systemName: "plus"), for: .normal)
      addItemBTN.imageView?.contentMode = .scaleAspectFit
      addItemBTN.imageView?.clipsToBounds = true
      addItemBTN.imageView?.tintColor = .black
      addItemBTN.backgroundColor = .systemGreen
      
      addItemBTN.layer.cornerRadius = 28
      addItemBTN.layer.shadowRadius = 15
      addItemBTN.layer.shadowOpacity = 0.2
      addItemBTN.layer.masksToBounds = false
      addItemBTN.layer.shadowColor = UIColor.label.cgColor
      addItemBTN.layer.shadowOffset = CGSize(width: 0, height: 0)
      
      addSubview(tableView)
      addSubview(addItemBTN)
      
      setupAutoLayout()
   }
   
   private func setupAutoLayout() {
      addItemBTN.translatesAutoresizingMaskIntoConstraints = false
      addItemBTN.imageView?.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         addItemBTN.imageView!.widthAnchor.constraint(equalToConstant: 30),
         addItemBTN.imageView!.heightAnchor.constraint(equalToConstant: 30),
         addItemBTN.widthAnchor.constraint(equalToConstant: 56),
         addItemBTN.heightAnchor.constraint(equalToConstant: 56),
         addItemBTN.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
         addItemBTN.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
      ])
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

