import UIKit
import RxSwift

class RegisterViewController: BaseStatefulController<[City]>,
    UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var streetTextField: UITextField!
    @IBOutlet private weak var numberTextField: UITextField!
    @IBOutlet private weak var zipcodeTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    var registerViewModel: RegisterViewModel! {
        didSet {
            viewModel = registerViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private let cityPicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.inputView = cityPicker
        cityPicker.delegate = self
    }

    @IBAction func performRegistration(_ sender: Any) {
        guard let name = nameTextField.text, let lastName = lastnameTextField.text,
            let email = emailTextField.text, let password = passwordTextField.text,
            let cityId = registerViewModel.cities.first(where: { $0.name == cityTextField.text })?.id,
            let street = streetTextField.text, let number = numberTextField.text,
            let zipcode = zipcodeTextField.text
            else { return }
        let registrationParameters = RegisterParameters(name: name, lastname: lastName,
                                                        email: email, password: password,
                                                        cityId: cityId, address: "\(street), \(number)",
                                                        zipcode: zipcode)
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
                debugPrint(error)
            })
            .disposed(by: disposeBag)
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

}
