import UIKit
import RxSwift

class ChefLoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: RoundedButton!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        passwordTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)

        let loginModel = RoundedButtonViewModel(title: "Log in as chef", type: .squeezedOrange)
        loginButton.configure(with: loginModel)
    }

    @IBAction func loginAction(_ sender: Any) {
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

    @IBAction func standardLoginAction(_ sender: Any) {
        NavigationService.makeLoginRootController()
    }

}

extension ChefLoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
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

}
