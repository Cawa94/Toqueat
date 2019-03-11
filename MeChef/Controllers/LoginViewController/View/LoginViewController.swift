import UIKit
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!

    var viewModel: LoginViewModel!
    private let disposeBag = DisposeBag()

    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text
            else { return }
        let bodyParameters = LoginParameters(email: email,
                                             password: password)
        NetworkService.shared.login(loginBody: bodyParameters)
            .flatMap { response -> Single<User> in
                SessionService.session = UserSession(authToken: response.authToken, city: nil, user: nil)
                return NetworkService.shared.getUserInfo()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { user in
                SessionService.updateWith(user: BaseResultWithIdAndName(id: user.id,
                                                                        name: user.name),
                                          city: user.city)
                CartService.getCartOrCreateNew()
                NavigationService.replaceLastTabItem()
            }, onError: { error in
                debugPrint(error)
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
