import UIKit
import SwiftValidator
import RxSwift

protocol ContainerVolumeDelegate: class {
    func calculated(volume: Int, minContainerSize: String)
}

class ContainerVolumeViewController: UIViewController {

    @IBOutlet private weak var widthTextField: UITextField!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var depthTextField: UITextField!
    @IBOutlet private weak var calculateVolumeButton: RoundedButton!

    weak var delegate: ContainerVolumeDelegate?
    private let validator = Validator()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureXibElements()
        addValidationRules()
    }

    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationController?.isNavigationBarHidden = false
        title = .dishContainerVolume()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .commonCancel(),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(closeScreen))
    }

    @objc func closeScreen() {
        NavigationService.dismissTopController()
    }

    @IBAction func calculateVolumeAction(_ sender: Any) {
        validator.validate(self)
    }

    func configureXibElements() {
        widthTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        heightTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        depthTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)

        let calculateModel = RoundedButtonViewModel(title: String.dishContainerCalculateVolume(),
                                                    type: .squeezedOrange)
        calculateVolumeButton.configure(with: calculateModel)

        let widthValidation = widthTextField.rx.text.map({$0?.isNotEmpty ?? false}).asObservable()
        let heightValidation = heightTextField.rx.text.map({$0?.isNotEmpty ?? false}).asObservable()
        let depthValidation = depthTextField.rx.text.map({$0?.isNotEmpty ?? false}).asObservable()

        let showButtonObservable = Observable.combineLatest(widthValidation,
                                                            heightValidation,
                                                            depthValidation) {
            return $0 && $1 && $2
        }.map { !$0 }

        showButtonObservable.bind(to: calculateVolumeButton.rx.isHidden).disposed(by: disposeBag)
    }

    func addValidationRules() {
        validator.registerField(widthTextField, rules: [RequiredRule()])
        validator.registerField(heightTextField, rules: [RequiredRule()])
        validator.registerField(depthTextField, rules: [RequiredRule()])
    }

}

extension ContainerVolumeViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let widthText = widthTextField.text,
            let heightText = heightTextField.text,
            let depthText = depthTextField.text,
            let width = Int(widthText),
            let height = Int(heightText),
            let depth = Int(depthText),
            let minContainer = StuartContainer.getMinimumContainerSizeFor(sizes: [width, height, depth])
            else { return }
        debugPrint("CONTAINER: \(minContainer.rawValue)")
        let volume = width * height * depth
        delegate?.calculated(volume: volume,
                             minContainerSize: minContainer.rawValue)
        NavigationService.dismissTopController()
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.addLine(position: .bottom, color: .red, width: 1)
            }
        }
    }

}
