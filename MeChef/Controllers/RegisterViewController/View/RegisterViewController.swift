import UIKit
import RxSwift
import SwiftValidator

class RegisterViewController: BaseStatefulController<[City]>,
UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var streetTextField: UITextField!
    @IBOutlet private weak var apartmentTextField: UITextField!
    @IBOutlet private weak var zipcodeTextField: UITextField!
    @IBOutlet private weak var registerButton: RoundedButton!

    var registerViewModel: RegisterViewModel! {
        didSet {
            viewModel = registerViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private let validator = Validator()
    private let cityPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        addLinesToTextfields()
        addValidationRules()

        cityTextField.inputView = cityPicker
        cityPicker.delegate = self

        let registerModel = RoundedButtonViewModel(title: "Register", type: .squeezedOrange)
        registerButton.configure(with: registerModel)
    }

    @IBAction func performRegistration(_ sender: Any) {
        validator.validate(self)
    }

    @IBAction func backToLogin(_ sender: Any) {
        NavigationService.makeLoginRootController()
    }

    func addLinesToTextfields() {
        nameTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        lastnameTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        emailTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        passwordTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        confirmPasswordTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        phoneTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        cityTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        streetTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        apartmentTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        zipcodeTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
    }

    func addValidationRules() {
        validator.registerField(nameTextField, rules: [RequiredRule()])
        validator.registerField(lastnameTextField, rules: [RequiredRule()])
        validator.registerField(emailTextField, rules: [RequiredRule()])
        validator.registerField(passwordTextField, rules: [RequiredRule()])
        validator.registerField(confirmPasswordTextField, rules: [RequiredRule()])
        validator.registerField(phoneTextField, rules: [RequiredRule()])
        validator.registerField(cityTextField, rules: [RequiredRule()])
        validator.registerField(streetTextField, rules: [RequiredRule()])
        validator.registerField(apartmentTextField, rules: [RequiredRule()])
        validator.registerField(zipcodeTextField, rules: [RequiredRule()])
    }

    func validationSuccessful() {
        guard let name = nameTextField.text, let lastName = lastnameTextField.text,
            let email = emailTextField.text, let password = passwordTextField.text,
            let cityId = registerViewModel.cities.first(where: { $0.name == cityTextField.text })?.id,
            let phone = phoneTextField.text, let street = streetTextField.text,
            let apartment = apartmentTextField.text, let zipcode = zipcodeTextField.text
            else { return }
        let registrationParameters = UserCreateParameters(name: name, lastname: lastName,
                                                          email: email, password: password,
                                                          cityId: cityId, address: street,
                                                          zipcode: zipcode, apartment: apartment,
                                                          phone: phone)
        NetworkService.shared.register(registerParameters: registrationParameters)
            .flatMap { response -> Single<User> in
                SessionService.session = UserSession(authToken: response.authToken, user: nil, chef: nil)
                return NetworkService.shared.getUserInfo()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { user in
                SessionService.updateWith(user: user)
                CartService.localCart = .new
                NavigationService.makeMainTabRootController()
            }, onError: { error in
                let message: String
                if let serverError = error.serverError,
                    let title = serverError.error {
                    message = title
                } else {
                    message = "Something went wrong"
                }
                self.presentAlertWith(title: "WARNING", message: message)
            })
            .disposed(by: disposeBag)
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

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        registerViewModel.cities = registerViewModel.result
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return registerViewModel.cities.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return registerViewModel.cities[row].name
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = registerViewModel.cities[row].name
    }

    // MARK: - UITextFieldDelegate related methods

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 6 {
            guard let city = cityTextField.text, city != ""
                else {
                    presentAlertWith(title: "WARNING", message: "Please select a city first")
                    return false
            }
            let addressController = NavigationService.addressViewController(city: city)
            addressController.selectedAddressDriver
                .drive(textField.rx.text)
                .disposed(by: disposeBag)
            NavigationService.presentAddress(controller: addressController)
            return false
        } else {
            return true
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }

    // swiftlint:disable all
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            textField.placeholder = "Name"
        case lastnameTextField:
            textField.placeholder = "Lastname"
        case emailTextField:
            textField.placeholder = "Email"
        case passwordTextField:
            textField.placeholder = "Password"
        case confirmPasswordTextField:
            textField.placeholder = "Confirm password"
        case phoneTextField:
            textField.placeholder = "Phone"
        case cityTextField:
            textField.placeholder = "City"
        case streetTextField:
            textField.placeholder = "Street"
        case apartmentTextField:
            textField.placeholder = "Apartment"
        case zipcodeTextField:
            textField.placeholder = "Zipcode"
        default:
            break
        }
    }

}
