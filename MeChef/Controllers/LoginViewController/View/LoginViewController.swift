import UIKit
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func loginAction(_ sender: Any) {
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
                debugPrint(error)
            })
            .disposed(by: disposeBag)
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
