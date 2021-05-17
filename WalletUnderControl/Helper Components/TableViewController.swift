//
//  TableViewController.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 16/05/2021.
//

import UIKit

protocol IdentifiableCell: UITableViewCell {
   static var id: String { get }
   static var height: CGFloat { get }
}

class TableViewController<T, Cell: IdentifiableCell>: UITableViewController {
   
   var items: [T]
   var configure: (Cell, T) -> Void
   var selectHandler: ((T) -> Void)?
   
   init(items: [T], configure: @escaping (Cell, T) -> Void, selectHandler: ((T) -> Void)? = nil) {
      self.items = items
      self.configure = configure
      self.selectHandler = selectHandler
      super.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.rowHeight = Cell.height
      tableView.register(Cell.self, forCellReuseIdentifier: Cell.id)
      
      let closeAction = UIAction() { [unowned self] _ in dismiss(animated: true) }
      let cancelBTN = UIBarButtonItem(systemItem: .cancel, primaryAction: closeAction)
      navigationItem.rightBarButtonItem = cancelBTN
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: -- TableView Configuration
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: Cell.id, for: indexPath) as! Cell
      let item = items[indexPath.row]
      configure(cell, item)
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      if let selectHandler = selectHandler {
         let item = items[indexPath.row]
         selectHandler(item)
      }
   }
}

