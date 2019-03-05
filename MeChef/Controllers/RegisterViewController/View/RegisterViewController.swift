import UIKit
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var lastnameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var registerButton: UIButton!

    var viewModel: RegisterViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func performRegistration(_ sender: Any) {
        guard let name = nameTextField.text, let lastName = lastnameTextField.text,
            let email = emailTextField.text, let password = passwordTextField.text
            else { return }
        let registrationParameters = RegisterParameters(name: name, lastname: lastName,
                                                        email: email, password: password)
        NetworkService.shared.register(registerParameters: registrationParameters)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { userSession in
                SessionService.user = userSession
                NavigationService.replaceLastTabItem()
            }, onError: { error in
                debugPrint(error)
            })
            .disposed(by: disposeBag)
    }

}

extension RegisterViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 4, let nextField = self.view.viewWithTag(textField.tag+1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}
