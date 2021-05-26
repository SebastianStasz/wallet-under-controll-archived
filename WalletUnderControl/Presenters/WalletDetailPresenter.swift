//
//  WalletDetailPresenter.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 26/05/2021.
//

import Foundation

protocol WalletDetailPresenterProtocol: AnyObject {
   init(view: WalletDetailView, wallet: WalletEntity, settings: SettingsProtocol)
   
   func viewDidLoad()
   func addCashFlowBtnTapped(type: CashFlowType)
}


class WalletDetailPresenter {
   
   private weak var view: WalletDetailView?
   private let settings: SettingsProtocol
   private let wallet: WalletEntity
   
   required init(view: WalletDetailView, wallet: WalletEntity, settings: SettingsProtocol) {
      self.view = view
      self.wallet = wallet
      self.settings = settings
   }
   
   private var isInPrimaryCurrency: Bool {
      wallet.currency.code == settings.primaryCurrencyCode
   }
}

// MARK: -- Actions

extension WalletDetailPresenter: WalletDetailPresenterProtocol {
   
   func viewDidLoad() {
      let primaryCurrencyCode = isInPrimaryCurrency ? nil : settings.primaryCurrencyCode
      let walletInfo = WalletDetailVC.Info(wallet: wallet, primaryCurrencyCode: primaryCurrencyCode)
      view?.updateWalletInfo.send(walletInfo)
   }
   
   func addCashFlowBtnTapped(type: CashFlowType) {
      let vc = CashFlowAlertVC(ofType: type, forWallet: wallet)
      view?.cashFlowAlert = CashFlowAlert(cashFlowAlertVC: vc)
   }
}
