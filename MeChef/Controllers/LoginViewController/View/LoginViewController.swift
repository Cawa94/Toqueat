import UIKit
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!

    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else { return }
        let bodyParameters = LoginParameters(email: email,
                                             password: password)
        NetworkService.shared.login(loginBody: bodyParameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { userSession in
                SessionService.user = userSession
                NavigationService.replaceLastTabItem()
            })
            .disposed(by: disposeBag)
    }

    @IBAction func registerAction(_ sender: Any) {
        NavigationService.pushRegisterViewController()
    }

}

extension LoginViewController: UITextFieldDelegate {

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
