import UIKit
import RxSwift
import SwiftValidator

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: RoundedButton!
    @IBOutlet private weak var registerButton: RoundedButton!

    private let disposeBag = DisposeBag()
    private let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        addLinesToTextfields()
        addValidationRules()

        let loginModel = RoundedButtonViewModel(title: "Log in", type: .squeezedOrange)
        loginButton.configure(with: loginModel)

        let registerModel = RoundedButtonViewModel(title: "Register", type: .squeezedWhite)
        registerButton.configure(with: registerModel)
    }

    func addLinesToTextfields() {
        emailTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        passwordTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
    }

    func addValidationRules() {
        validator.registerField(emailTextField, rules: [RequiredRule()])
        validator.registerField(passwordTextField, rules: [RequiredRule()])
    }

    @IBAction func loginAction(_ sender: Any) {
        validator.validate(self)
    }

    @IBAction func registerAction(_ sender: Any) {
        NavigationService.makeRegisterRootController()
    }

    @IBAction func loginAsChefAction(_ sender: Any) {
        NavigationService.makeChefLoginRootController()
    }

}

extension LoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            textField.placeholder = "Email"
        case passwordTextField:
            textField.placeholder = "Password"
        default:
            break
        }
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 1, let nextField = self.view.viewWithTag(1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }

}

extension LoginViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else { return }
        let bodyParameters = LoginParameters(email: email,
                                             password: password,
                                             isChef: false)
        NetworkService.shared.login(loginBody: bodyParameters)
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

}
