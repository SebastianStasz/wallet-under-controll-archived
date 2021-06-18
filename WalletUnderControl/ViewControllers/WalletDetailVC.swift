//
//  WalletDetailVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 24/05/2021.
//

import CoreData
import Combine
import UIKit

protocol WalletDetailView: AnyObject {
    var updateWalletInfo: PassthroughSubject<WalletDetailVC.Info, Never> { get set }
    var cashFlowAlert: CashFlowAlert? { get set}

    func present(_ alert: UIAlertController)
    func reloadTableView()
}


class WalletDetailVC: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    var updateWalletInfo = PassthroughSubject<Info, Never>()
    @Published var cashFlowAlert: CashFlowAlert?

    private let headerColor1 = UIColor(red: 69/255, green: 94/255, blue: 170/255, alpha: 1)
    private let headerColor2 = UIColor(red: 35/255, green: 69/255, blue: 160/255, alpha: 1)

    private var presenter: WalletDetailPresenterProtocol?

    private var fetchedResultsController: NSFetchedResultsController<NSManagedObject> {
        presenter!.cashFlowController.fetchedResultsController
    }

    // View Components
    private let headerView = UIView()
    private let cashFlowTBV = UITableView()

    private let balanceInWalletCurrencyLabel = UILabel()
    private var balanceInPrimaryCurrencyLabel = UILabel()
    private var walletIconImageView = UIImageView()

    private let addIncomeBTN = UIButton()
    private let addExpenseBTN = UIButton()
    private let anotherActionBTN = UIButton()
    private let openStatisticsBTN = UIButton()

    init(wallet: WalletEntity, settings: SettingsProtocol = Settings.shared) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = WalletDetailPresenter(view: self, wallet: wallet, settings: settings)
        listenForViewUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        fetchedResultsController.delegate = self
        cashFlowTBV.register(CashFlowCell.self, forCellReuseIdentifier: CashFlowCell.id)
        cashFlowTBV.delegate = self
        cashFlowTBV.dataSource = self
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: -- TableView Setup

extension WalletDetailVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        fetchedResultsController.sections?[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CashFlowCell") as! CashFlowCell
        let cashFlow = fetchedResultsController.object(at: indexPath) as! CashFlowEntity
        cell.configure(cashFlow: cashFlow)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cashFlow = fetchedResultsController.object(at: indexPath) as! CashFlowEntity

        let menuConfig = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            let deleteBTN = UIAction.delete { [unowned self] in
                presenter?.deleteCashFlowBtnTapped(for: cashFlow)
            }

            let editBTN = UIAction.edit { [unowned self] in
                presenter?.editCashFlowBtnTapped(for: cashFlow)
            }

            return UIMenu(title: cashFlow.name, children: [editBTN, deleteBTN])
        }

        return menuConfig
    }
}

// MARK: -- FetchedResultsControllerDelegate Setup

extension WalletDetailVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        func insertNewSection() {
            cashFlowTBV.insertSections([newIndexPath!.section], with: .automatic)
        }
        func deleteSection() {
            cashFlowTBV.deleteSections([indexPath!.section], with: .automatic)
        }
        func inertNewRow() {
            cashFlowTBV.insertRows(at: [newIndexPath!], with: .automatic)
        }
        func deleteOldRow() {
            cashFlowTBV.deleteRows(at: [indexPath!], with: .left)
        }

        func dateHasChanged() {
            let differenceInSectionsAfterUpdate = cashFlowTBV.numberOfSections - fetchedResultsController.sections!.count
            switch differenceInSectionsAfterUpdate {
            // Moved to new section without deleting
            case _ where differenceInSectionsAfterUpdate < 0:
                insertNewSection() ; deleteOldRow() ; inertNewRow()

            // Moved to existing section with deleting old
            case _ where differenceInSectionsAfterUpdate > 0:
                deleteSection() ; inertNewRow()

            // Moved to new section with deleting old AND moved to existing section
            default:
                cashFlowTBV.reloadSections([indexPath!.section], with: .automatic)
                cashFlowTBV.reloadSections([newIndexPath!.section], with: .automatic)
            }
        }

        cashFlowTBV.beginUpdates()
        switch type {
        case .delete:
            let isLastElement = cashFlowTBV.numberOfRows(inSection: indexPath!.section) == 1
            isLastElement ? deleteSection() : deleteOldRow()

        case .insert:
            inertNewRow()
            let isNewSection = cashFlowTBV.numberOfSections < fetchedResultsController.sections!.count
            if isNewSection { insertNewSection() }

        case .update:
            cashFlowTBV.reloadRows(at: [indexPath!], with: .automatic)

        case .move: dateHasChanged()

        default: break
        }
        cashFlowTBV.endUpdates()
        presenter?.contextHasChanged()
    }
}

// MARK: -- View Setup

extension WalletDetailVC {

    private func setupView() {
        setupNavigationController()
        view.backgroundColor = .systemBackground
        walletIconImageView.contentMode = .scaleAspectFit

        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 320)
        headerView.setGradientBackground(color1: headerColor1, color2: headerColor2)

        balanceInWalletCurrencyLabel.font = .systemFont(ofSize: 26, weight: .medium)
        balanceInWalletCurrencyLabel.textColor = .white
        balanceInPrimaryCurrencyLabel.textColor = .white

        let balanceStackView = UIStackView(arrangedSubviews: [balanceInWalletCurrencyLabel, balanceInPrimaryCurrencyLabel])
        balanceStackView.axis = .vertical

        let buttonsStackView = setupActionButtonStackView()

        let filterOptions = CashFlowFilter.allOptions
        let filterSegmentedControll = UISegmentedControl(items: filterOptions)
        filterSegmentedControll.selectedSegmentIndex = 0
        filterSegmentedControll.addTarget(self, action: #selector(filterSegmentedControlDidChange), for: .valueChanged)
        
        headerView.addSubview(balanceStackView)
        headerView.addSubview(buttonsStackView)
        headerView.addSubview(walletIconImageView)
        view.addSubview(headerView)
        view.addSubview(filterSegmentedControll)
        view.addSubview(cashFlowTBV)

        // MARK: Auto Layout

        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        walletIconImageView.translatesAutoresizingMaskIntoConstraints = false
        filterSegmentedControll.translatesAutoresizingMaskIntoConstraints = false
        cashFlowTBV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            walletIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            walletIconImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            walletIconImageView.heightAnchor.constraint(equalToConstant: 40),
            walletIconImageView.widthAnchor.constraint(equalToConstant: 40),

            balanceStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            balanceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),

            buttonsStackView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            filterSegmentedControll.topAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor, constant: 20),
            filterSegmentedControll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterSegmentedControll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            cashFlowTBV.topAnchor.constraint(equalTo: filterSegmentedControll.bottomAnchor, constant: 20),
            cashFlowTBV.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cashFlowTBV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cashFlowTBV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupActionButtonStackView() -> UIStackView {
        let buttonsStackView = UIStackView()
        buttonsStackView.distribution = .equalCentering
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20

        let actionBTNs = [anotherActionBTN, openStatisticsBTN, addIncomeBTN, addExpenseBTN]

        for (btn, btnInfo) in zip(actionBTNs, actionButtons.allCases) {
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 15
            btn.backgroundColor = .white
            btn.imageView?.tintColor = headerColor2
            btn.setImage(btnInfo.img(), for: .normal)
            btn.imageView?.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)

            let btnLabel = UILabel()
            btnLabel.text = btnInfo.name
            btnLabel.textColor = .systemGray
            btnLabel.font = .systemFont(ofSize: 14, weight: .medium)

            let btnStack = UIStackView(arrangedSubviews: [btn, btnLabel])
            btnStack.alignment = .center
            btnStack.axis = .vertical
            btnStack.spacing = 10

            buttonsStackView.addArrangedSubview(btnStack)

            NSLayoutConstraint.activate([
                btn.heightAnchor.constraint(equalToConstant: 50),
                btn.widthAnchor.constraint(equalToConstant: 50),
            ])
        }

        let addIncomeAction = UIAction() { [unowned self] _ in
            addIncomeBTN.zoomIn()
            presenter?.addCashFlowBtnTapped(type: .income)
        }

        let addExpenseAction = UIAction() { [unowned self] _ in
            addExpenseBTN.zoomIn()
            presenter?.addCashFlowBtnTapped(type: .expense)
        }

        addIncomeBTN.addAction(addIncomeAction, for: .touchUpInside)
        addExpenseBTN.addAction(addExpenseAction, for: .touchUpInside)

        return buttonsStackView
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    @objc private func filterSegmentedControlDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            presenter?.cashFlowFilterChanged(to: .all)
        case 1:
            presenter?.cashFlowFilterChanged(to: .type(CashFlowType.income))
        case 2:
            presenter?.cashFlowFilterChanged(to: .type(CashFlowType.expense))
        default:
            fatalError("There should be only 3 options.")
        }
    }
}

// MARK: -- View Updates

extension WalletDetailVC: WalletDetailView {

    func reloadTableView() {
        cashFlowTBV.reloadData()
    }

    func present(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    func listenForViewUpdates() {

        $cashFlowAlert
            .compactMap { $0?.alert }
            .sink { [unowned self] in present($0, animated: true) }
            .store(in: &cancellables)

        updateWalletInfo.sink { [unowned self] in
            title = $0.name
            walletIconImageView = $0.image
            balanceInWalletCurrencyLabel.text = $0.balanceInWalletCurrency
            balanceInPrimaryCurrencyLabel.text = $0.balanceInPrimaryCurrency
            balanceInPrimaryCurrencyLabel.isHidden = $0.balanceInPrimaryCurrency == nil
        }
        .store(in: &cancellables)
    }
}

// MARK: -- Action Buttons

extension WalletDetailVC {

    enum actionButtons: CaseIterable {
        case other
        case statistics
        case addIncome
        case addExpense

        var name: String {
            switch self {
            case .other: return "Other"
            case .statistics: return "Stats"
            case .addIncome: return "Income"
            case .addExpense: return "Expense"
            }
        }

        func img() -> UIImage {
            UIImage(systemName: imgName)!
        }

        private var imgName: String {
            switch self {
            case .other: return "square.dashed"
            case .statistics: return "waveform.path.ecg"
            case .addIncome: return "plus.square"
            case .addExpense: return "minus.square"
            }
        }
    }
}

// MARK: -- Wallet Info

extension WalletDetailVC {

    struct Info {
        let name: String
        let type: String
        let image: UIImageView
        let balanceInWalletCurrency: String
        let balanceInPrimaryCurrency: String?

        init(wallet: WalletEntity, primaryCurrencyCode: String?) {
            name = wallet.name
            type = wallet.type.name
            image = wallet.iconView
            balanceInWalletCurrency = wallet.availableBalanceStr

            if let code = primaryCurrencyCode {
                let balanceInPrimaryCurrency = wallet.availableBalanceStr(in: code)
                self.balanceInPrimaryCurrency = balanceInPrimaryCurrency
            } else {
                balanceInPrimaryCurrency = nil
            }
        }
    }
}

