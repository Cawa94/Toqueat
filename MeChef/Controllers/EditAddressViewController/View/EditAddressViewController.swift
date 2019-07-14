import UIKit
import RxSwift
import SwiftValidator

class EditAddressViewController: BaseStatefulController<[City]> {

    @IBOutlet private weak var tableView: UITableView!

    var editAddressViewModel: EditAddressViewModel! {
        didSet {
            viewModel = editAddressViewModel
        }
    }

    private let validator = Validator()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        tableView.register(UINib(nibName: "EditFieldTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "EditFieldTableViewCell")
    }

    override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = .profileMyAddress()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .commonSave(),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(updateDetails))
    }

    @objc func updateDetails() {
        validator.validate(self)
    }

    func updateChefAddress(parameters: AddressUpdateParameters) {
        guard let chefId = editAddressViewModel.chef?.id
            else { return }
        let validateAddress = NetworkService.shared.validateAddress(parameters.address,
                                                                    phone: editAddressViewModel.chef?.phone,
                                                                    isChef: true)
        let updateChefAddressSingle = validateAddress.flatMap { _ in
                NetworkService.shared.updateChefAddress(parameters: parameters,
                                                        chefId: chefId)
        }
        hudOperationWithSingle(operationSingle: updateChefAddressSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: .commonSuccess(),
                                    message: .profileAddressUpdated(),
                                    actions: [ UIAlertAction(title: .commonOk(), style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadChefProfile = true
                                    })])
        }, disposeBag: disposeBag)
    }

    func updateUserAddress(parameters: AddressUpdateParameters) {
        guard let userId = editAddressViewModel.user?.id
            else { return }
        let validateAddress = NetworkService.shared.validateAddress(parameters.address,
                                                                    phone: editAddressViewModel.user?.phone,
                                                                    isChef: false)
        let updateUserAddressSingle = validateAddress.flatMap { _ in
            NetworkService.shared.updateUserAddress(parameters: parameters,
                                                    userId: userId)
        }
        hudOperationWithSingle(operationSingle: updateUserAddressSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: .commonSuccess(),
                                    message: .profileAddressUpdated(),
                                    actions: [ UIAlertAction(title: .commonOk(), style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadUserProfile = true
                                    })])
        }, disposeBag: disposeBag)
    }

    // MARK: - StatefulViewController related methods

    override func onLoadingState() {
        super.onLoadingState()

        tableView.reloadData()
    }

    override func onResultsState() {
        tableView.reloadData()

        super.onResultsState()
    }

}

extension EditAddressViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "EditFieldTableViewCell",
                                             for: indexPath)
        configure(cell, at: indexPath, isLoading: editAddressViewModel.isLoading)
        return cell
    }

    func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let editFieldCell as EditFieldTableViewCell:
            editFieldCell.configureWith(loading: true)
        default:
            break
        }
    }

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let editFieldCell as EditFieldTableViewCell:
            let cellViewModel: EditFieldTableViewModel
            switch indexPath.row {
            case 0:
                let placeholderText = "\(String.addressStreet()), \(String.addressNumber())"
                cellViewModel = EditFieldTableViewModel(fieldValue: editAddressViewModel.address,
                                                        placeholder: placeholderText)
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            case 1:
                let placeholderText = "\(String.addressFloor()), \(String.addressDoor()) (\(String.commonOptional()))"
                cellViewModel = EditFieldTableViewModel(fieldValue: editAddressViewModel.apartment,
                                                        placeholder: placeholderText)
            case 2:
                cellViewModel = EditFieldTableViewModel(fieldValue: editAddressViewModel.zipcode,
                                                        placeholder: .addressZipcode())
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            case 3:
                cellViewModel = EditFieldTableViewModel(fieldValue: editAddressViewModel.city,
                                                        placeholder: .addressCity(),
                                                        hideBottomLine: false,
                                                        pickerValues: editAddressViewModel.result.map { $0.name })
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            default:
                cellViewModel = EditFieldTableViewModel(fieldValue: nil, placeholder: "")
            }
            editFieldCell.configureWith(contentViewModel: cellViewModel)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UITableViewCell()
        headerCell.backgroundColor = .lightGrayBackgroundColor
        return headerCell
    }

}

extension EditAddressViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let addressCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditFieldTableViewCell,
            let address = addressCell.cellTextField.text,
            let zipcodeCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditFieldTableViewCell,
            let zipcode = zipcodeCell.cellTextField.text,
            let cityCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? EditFieldTableViewCell,
            let cityId = editAddressViewModel.result.first(where: { $0.name == cityCell.cellTextField.text })?.id
            else { return }

        let apartmentCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditFieldTableViewCell
        let addressParameters = AddressUpdateParameters(cityId: cityId, address: address,
                                                        zipcode: zipcode, apartment: apartmentCell?.cellTextField.text)
        if editAddressViewModel.isChef {
            updateChefAddress(parameters: addressParameters)
        } else {
            updateUserAddress(parameters: addressParameters)
        }
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
        }
    }

}
