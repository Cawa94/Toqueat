import UIKit
import RxSwift
import SwiftValidator

class ChefLoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: RoundedButton!

    private let disposeBag = DisposeBag()
    private let validator = Validator()

    override func viewDidLoad() {
        super.viewDidLoad()

        addLinesToTextfields()
        addValidationRules()

        let loginModel = RoundedButtonViewModel(title: "Log in as chef", type: .squeezedOrange)
        loginButton.configure(with: loginModel)
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

    @IBAction func standardLoginAction(_ sender: Any) {
        NavigationService.makeLoginRootController()
    }

}

extension ChefLoginViewController: UITextFieldDelegate {

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

extension ChefLoginViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else { return }
        let bodyParameters = LoginParameters(email: email,
                                             password: password,
                                             isChef: true)
        NetworkService.shared.login(loginBody: bodyParameters)
            .flatMap { response -> Single<Chef> in
                SessionService.session = UserSession(authToken: response.authToken,
                                                     user: nil,
                                                     chef: nil)
                return NetworkService.shared.getChefWith(chefId: response.chefId ?? -1)
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { chef in
                SessionService.updateWith(chef: chef)
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
