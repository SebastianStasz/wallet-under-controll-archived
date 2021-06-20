//
//  WalletDetailPresenter.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 26/05/2021.
//

import CoreData
import UIKit

protocol WalletDetailPresenterProtocol: AnyObject {
    init(view: WalletDetailView, wallet: WalletEntity, settings: SettingsProtocol, context: NSManagedObjectContext)
    
    var cashFlowController: FetchedResultsController<CashFlowEntity> { get }
    
    func viewDidLoad()
    func contextHasChanged()
    func addCashFlowBtnTapped(type: CashFlowType)
    func deleteCashFlowBtnTapped(for cashFlow: CashFlowEntity)
    func editCashFlowBtnTapped(for cashFlow: CashFlowEntity)
    func cashFlowFilterChanged(to filter: CashFlowFilter)
}


class WalletDetailPresenter {
    
    private weak var view: WalletDetailView?
    private let context: NSManagedObjectContext
    private let settings: SettingsProtocol
    private let wallet: WalletEntity
    let cashFlowController: FetchedResultsController<CashFlowEntity>
    
    required init(view: WalletDetailView,
                  wallet: WalletEntity,
                  settings: SettingsProtocol,
                  context: NSManagedObjectContext = SceneDelegate.context)
    {
        self.view = view
        self.wallet = wallet
        self.settings = settings
        self.context = context
        
        let sort = CashFlowEntity.sortByDateDESC
        let filter = CashFlowEntity.filter(wallet: wallet)
        cashFlowController = CashFlowEntity.fetchedResultsController(in: context, predicate: filter, sorting: [sort],
                                                                     sectionNameKeyPath: #keyPath(CashFlowEntity.yearAndMonth))
    }
    
    private var shouldDisplayPrimaryCurrency: Bool {
        wallet.currency.code != settings.primaryCurrencyCode && settings.isPrimaryCurrencyPresented
    }
}

// MARK: -- Actions

extension WalletDetailPresenter: WalletDetailPresenterProtocol {
    
    func cashFlowFilterChanged(to filter: CashFlowFilter) {
        switch filter {
        case .all:
            cashFlowController.changePredicate(CashFlowEntity.filter(wallet: wallet))
        case .type(let type):
            cashFlowController.changePredicate(CashFlowEntity.filter(wallet: wallet, type: type))
        }
        view?.reloadTableView()
    }
    
    func viewDidLoad() {
        let primaryCurrencyCode = shouldDisplayPrimaryCurrency ? settings.primaryCurrencyCode : nil
        let walletInfo = WalletDetailVC.Info(wallet: wallet, primaryCurrencyCode: primaryCurrencyCode)
        view?.updateWalletInfo.send(walletInfo)
    }
    
    func contextHasChanged() {
        viewDidLoad()
    }
    
    func addCashFlowBtnTapped(type: CashFlowType) {
        let vc = CashFlowAlertVC(ofType: type, forWallet: wallet)
        view?.cashFlowAlert = CashFlowAlert(cashFlowAlertVC: vc)
    }
    
    func editCashFlowBtnTapped(for cashFlow: CashFlowEntity) {
        let vc = CashFlowAlertVC(editing: cashFlow)
        view?.cashFlowAlert = CashFlowAlert(cashFlowAlertVC: vc)
    }
    
    func deleteCashFlowBtnTapped(for cashFlow: CashFlowEntity) {
        let title = "Delete \"\(cashFlow.name)\""
        let message = "All data will be deleted!"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction.deleteAction { [unowned self] in context.delete(cashFlow) })
        ac.addAction(UIAlertAction.cancel)
        
        view?.present(ac)
    }
}

enum CashFlowFilter {
    case all
    case type(CashFlowType)
    
    var name: String {
        switch self {
        case .all:
            return "All"
        case .type(let type):
            return "\(type.name)s"
        }
    }
    
    static var allOptions: [String] {
        [Self.all.name, Self.type(.income).name, Self.type(.expense).name]
    }
}
