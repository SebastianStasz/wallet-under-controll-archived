//
//  WalletFormView.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 13/05/2021.
//

import UIKit

class WalletFormView: UIView {
   
   private var walletDetailsStackView: UIStackView!
   private var iconSettingsStackView: UIStackView!
   private var currencyPickerStackView: UIStackView!
   
   private let textFieldPadding = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
   var nameTextField: MainTextField!
   var balanceTextField: MainTextField!
   
   var selectCurrencyBTN = UIButton()
   var selectWalletTypeBTN = UIButton()
   var selectedCurrencyLabel = UILabel()
   var selectedWalletTypeLabel = UILabel()
   
   var nameValidationLabel: PaddingLabel!
   var balanceValidationLabel: PaddingLabel!
   var currencyPickerValidationLabel: PaddingLabel!
   var walletTypePickerValidationLabel: PaddingLabel!
   
   var pickerView = UIPickerView()
   var submitButton: MainButton!
   
   init() {
      super.init(frame: .zero)
      setup()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- View Setup and Auto Layout

extension WalletFormView {
   
   private func setup() {
      // Sections Headers Labels
      let detailsHeaderLabel = getSectionHeaderLabel(with: "Details")
      let iconHeaderLabel = getSectionHeaderLabel(with: "Icon")
      
      // Wallet Name Text Field
      let nameTextField = ViewComponents.mainTextField(title: "Wallet Name", placeholder: "My Wallet", padding: textFieldPadding)
      let nameValidationLabel = ViewComponents.validationMessageLabel()
      let nameRowStackView = UIStackView(arrangedSubviews: [nameTextField, nameValidationLabel])
      nameRowStackView.axis = .vertical
      
      // Initial Balance Text Field
      let balanceTextField = ViewComponents.mainTextField(title: "Initial Balance", placeholder: "1000", padding: textFieldPadding)
      let balanceValidationLabel = ViewComponents.validationMessageLabel()
      let balanceRowStackView = UIStackView(arrangedSubviews: [balanceTextField, balanceValidationLabel])
      balanceTextField.keyboardType = .decimalPad
      balanceRowStackView.axis = .vertical
      
      // Currency Picker Row
      let currencyPicker = setupPickerRow(for: selectCurrencyBTN, withTitle: "Currency", valueLabel: selectedCurrencyLabel)
      let currencyPickerValidationLabel = ViewComponents.validationMessageLabel()
      currencyPickerStackView = UIStackView(arrangedSubviews: [currencyPicker, currencyPickerValidationLabel])
      currencyPickerStackView.axis = .vertical
      selectedCurrencyLabel.text = "------"
      
      // Wallet Type Picker Row
      let walletTypePicker = setupPickerRow(for: selectWalletTypeBTN, withTitle: "Wallet Type", valueLabel: selectedWalletTypeLabel)
      let walletTypePickerValidationLabel = ViewComponents.validationMessageLabel()
      let walletTypePickerRowStack = UIStackView(arrangedSubviews: [walletTypePicker, walletTypePickerValidationLabel])
      walletTypePickerRowStack.axis = .vertical
      selectedWalletTypeLabel.text = "------"
      
      // Wallet Detail Stack View
      walletDetailsStackView = UIStackView(arrangedSubviews: [detailsHeaderLabel, nameRowStackView, balanceRowStackView, currencyPickerStackView, walletTypePickerRowStack])
      walletDetailsStackView.axis = .vertical
      walletDetailsStackView.spacing = 5
      
      // Icon Settings Stack View
      iconSettingsStackView = UIStackView(arrangedSubviews: [iconHeaderLabel, pickerView])
      iconSettingsStackView.axis = .vertical
      iconSettingsStackView.spacing = 5
      
      // Submit Button
      submitButton = ViewComponents.mainButton(title: "Create")
      submitButton.isEnabled = false

      // Main View
      backgroundColor = .secondarySystemBackground
      addSubview(walletDetailsStackView)
      addSubview(iconSettingsStackView)
      addSubview(submitButton)
      setupAutoLayout()
      
      self.nameTextField = nameTextField
      self.balanceTextField = balanceTextField
      self.nameValidationLabel = nameValidationLabel
      self.balanceValidationLabel = balanceValidationLabel
      self.currencyPickerValidationLabel = currencyPickerValidationLabel
      self.walletTypePickerValidationLabel = walletTypePickerValidationLabel
   }
   
   private func setupAutoLayout() {
      walletDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
      iconSettingsStackView.translatesAutoresizingMaskIntoConstraints = false
      submitButton.translatesAutoresizingMaskIntoConstraints = false
      pickerView.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         walletDetailsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
         walletDetailsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         walletDetailsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
         
         iconSettingsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         iconSettingsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
         iconSettingsStackView.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -20),
         iconSettingsStackView.topAnchor.constraint(greaterThanOrEqualTo: walletDetailsStackView.bottomAnchor, constant: 20),
         
         pickerView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
         
         submitButton.heightAnchor.constraint(equalToConstant: 50),
         submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
         submitButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
      ])
   }
}

// MARK: -- Wallet Form View Components Setup

extension WalletFormView {
   
   private func setupPickerRow(for button: UIButton, withTitle title: String, valueLabel: UILabel) -> UIStackView {
      button.setTitle(title, for: .normal)
      button.setTitleColor(.systemBlue, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 17)
      button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      
      let arrowIMGView = UIImageView()
      arrowIMGView.image = UIImage(systemName: "chevron.right")
      arrowIMGView.contentMode = .scaleAspectFit
      arrowIMGView.tintColor = .systemGray3
      
      let innerStackView = UIStackView(arrangedSubviews: [valueLabel, arrowIMGView])
      innerStackView.axis = .horizontal
      innerStackView.spacing = 10
      
      let rowStackView = UIStackView(arrangedSubviews: [button, innerStackView])
      rowStackView.layoutMargins = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
      rowStackView.isLayoutMarginsRelativeArrangement = true
      rowStackView.backgroundColor = .tertiarySystemBackground
      rowStackView.layer.borderColor = UIColor.systemGray6.cgColor
      rowStackView.distribution = .equalSpacing
      rowStackView.layer.cornerRadius = 5
      rowStackView.layer.borderWidth = 0.3
      rowStackView.clipsToBounds = true
      rowStackView.axis = .horizontal
      
      return rowStackView
   }
   
   private func getSectionHeaderLabel(with text: String) -> UILabel {
      let label = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 10, bottom: 9, right: 9))
      label.text = text.uppercased()
      label.textColor = .systemGray
      label.font = .systemFont(ofSize: 13)
      label.addCharacterSpacing(kernValue: 2)
      
      return label
   }
}

extension WalletFormView {
   
   func setupForEditing(_ wallet: WalletEntity) {
      nameTextField.insertText(wallet.name)
      balanceTextField.insertText(String(wallet.initialBalance))
      selectedCurrencyLabel.text = wallet.currency.code
      selectedWalletTypeLabel.text = wallet.type.name
      submitButton.setTitle("Update", for: .normal)
      
      balanceTextField.alpha = 0.5
      currencyPickerStackView.alpha = 0.5
      balanceTextField.isEnabled = false
      selectCurrencyBTN.isEnabled = false
   }
}

