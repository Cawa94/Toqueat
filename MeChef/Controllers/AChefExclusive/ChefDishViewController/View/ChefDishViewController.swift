import UIKit
import RxSwift
import Nuke
import SwiftValidator
import CropViewController

private extension CGFloat {
    static let maxAvatarDimension: CGFloat = 1_080
}

class ChefDishViewController: BaseStatefulController<ChefDishViewModel.ResultType>,
    UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var maxQuantityTextField: UITextField!
    @IBOutlet private weak var typeTextField: UITextField!
    @IBOutlet private weak var servingsTextField: UITextField!
    @IBOutlet private weak var ingredientsTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var toggleDishButton: RoundedButton!

    private var placeholderLabel: UILabel!

    var chefDishViewModel: ChefDishViewModel! {
        didSet {
            viewModel = chefDishViewModel
        }
    }

    private let validator = Validator()
    private var newImageData: Data?
    private let disposeBag = DisposeBag()
    private let typePicker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureXibElements()
        addValidationRules()
    }

    override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = chefDishViewModel.isNewDish ? String.chefAddDish() : String.editDishTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: .commonSave(),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(save))
    }

    @objc func save() {
        validator.validate(self)
    }

    @IBAction func toggleDishAction(_ sender: Any) {
        guard let dishId = chefDishViewModel.result.dish?.id
            else { return }
        let toggleSingle = NetworkService.shared.toggleDishAvailability(dishId: dishId)
        hudOperationWithSingle(operationSingle: toggleSingle,
                               onSuccessClosure: { dish in
                                self.presentAlertWith(
                                    title: "YEAH",
                                    message: dish.isActive ?? true
                                        ? String.editDishEnabled() : String.editDishDisabled(),
                                    actions: [ UIAlertAction(title: .commonOk(), style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadChefDishes = true
                                                                NavigationService.popNavigationTopController()
                                    })])
                                }, disposeBag: disposeBag)
    }

    func configureXibElements() {
        dishImageView.roundCorners(radii: 15.0)
        dishImageView.rx.tapGesture().when(.recognized).asDriver()
            .drive(onNext: { _ in
                self.pickImageAction()
            }).disposed(by: disposeBag)
        nameTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        priceTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        maxQuantityTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        typeTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        servingsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        ingredientsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        descriptionTextView.addLine(position: .bottom, color: .lightGray, width: 0.5)

        typeTextField.inputView = typePicker
        typePicker.delegate = self

        placeholderLabel = UILabel()
        placeholderLabel.text = .dishDescriptionPlaceholder()
        placeholderLabel.font = UIFont.regularFontOf(size: 16.0)
        placeholderLabel.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty

    }

    func populateXibElements() {
        if !chefDishViewModel.isNewDish, let dish = chefDishViewModel.result.dish {
            // Editing dish
            if let imageUrl = dish.imageLink {
                Nuke.loadImage(with: imageUrl, into: dishImageView)
                dishImageView.contentMode = .scaleAspectFill
            }
            nameTextField.text = dish.name
            priceTextField.text = dish.price.stringWithoutCurrency
            maxQuantityTextField.text = "\(dish.maxQuantity)"
            typeTextField.text = dish.categories?.first?.name
            servingsTextField.text = "\(dish.servings ?? 1)"
            ingredientsTextField.text = dish.ingredients
            descriptionTextView.text = dish.description
            placeholderLabel.isHidden = true

            toggleDishButton.isHidden = false
            let toggleDishModel = dish.isActive ?? true
            ? RoundedButtonViewModel(title: String.editDishDisable(), type: .squeezedRed)
            : RoundedButtonViewModel(title: String.editDishEnable(), type: .squeezedOrange)
            toggleDishButton.configure(with: toggleDishModel)
        } else {
            // New dish
            toggleDishButton.isHidden = true
        }
    }

    func addValidationRules() {
        validator.registerField(nameTextField, rules: [RequiredRule()])
        validator.registerField(priceTextField, rules: [RequiredRule()])
        validator.registerField(maxQuantityTextField, rules: [RequiredRule()])
        validator.registerField(typeTextField, rules: [RequiredRule()])
        validator.registerField(servingsTextField, rules: [RequiredRule()])
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    override func viewDidLayoutSubviews() {
        descriptionViewHeightConstraint.constant = descriptionTextView.contentSize.height > 300
            ? descriptionTextView.contentSize.height : 300
        contentViewHeightConstraint.constant = descriptionViewHeightConstraint.constant
        + 600 // Content without description
        + 60 // Remove dish button
    }

    func pickImageAction() {
        ImagePickerManager().pickImage(self) { image in
            self.didPick(image: image)
        }
    }

    func didPick(image: UIImage?) {
        guard let image = image
            else { return }

        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DishCategoryType.allValues.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DishCategoryType.allValues[row].name
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = DishCategoryType.allValues[row].name
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        populateXibElements()
        super.onResultsState()
    }

}

extension ChefDishViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let name = nameTextField.text,
            let categoryId = DishCategoryType.allValues.first(where: { $0.name == typeTextField.text })?.id,
            let servings = servingsTextField.text,
            let description = descriptionTextView.text,
            let priceText = priceTextField.text,
            let maxQuantityText = maxQuantityTextField.text,
            let chefId = SessionService.session?.chef?.id
            else { return }
        let price = NSDecimalNumber(string: "\(priceText.doubleValue)")
        let ingredients = ingredientsTextField.text
        let dishParameters = DishCreateParameters(name: name, description: description,
                                                  price: price, chefId: "\(chefId)",
                                                  categoryIds: [categoryId], ingredients: ingredients,
                                                  servings: Int(servings) ?? 1,
                                                  maxQuantity: Int(maxQuantityText) ?? 1)
        let operationSingle: Single<Void> = updateOrCreateDishSingle(parameters: dishParameters)

        hudOperationWithSingle(operationSingle: operationSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: "YEAH",
                                    message: self.chefDishViewModel.isNewDish
                                        ? .editDishCreated() : .editDishUpdated(),
                                    actions: [ UIAlertAction(title: .commonOk(), style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadChefDishes = true
                                                                if self.chefDishViewModel.isNewDish {
                                                                    NavigationService.popNavigationTopController()
                                                                }
                                    })])
        }, disposeBag: disposeBag)
    }

    func updateOrCreateDishSingle(parameters: DishCreateParameters) -> Single<Void> {
        if !chefDishViewModel.isNewDish, let dishId = chefDishViewModel.result.dish?.id {
            let updateDishSingle = NetworkService.shared.updateDishWith(parameters: parameters,
                                                                        dishId: dishId)
                .map { _ in
                    if let newImage = self.newImageData {
                        NetworkService.shared.uploadDishPicture(for: dishId,
                                                                imageData: newImage,
                                                                completion: { _ in })
                    }
            }
            return updateDishSingle
        } else {
            let createDishSingle = NetworkService.shared.createNewDishWith(parameters: parameters)
                .map { dish in
                    if let newImage = self.newImageData {
                        NetworkService.shared.uploadDishPicture(for: dish.id,
                                                                imageData: newImage,
                                                                completion: { _ in })
                    }
            }
            return createDishSingle
        }
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

extension ChefDishViewController: CropViewControllerDelegate {

    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let fixedImage = rotateImage(image: image)
            else { return }

        let imageSize = fixedImage.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let maxSize = max(imageWidth, imageHeight)
        let ratio = maxSize / min(maxSize, .maxAvatarDimension)
        let newSize = CGSize(width: imageWidth / ratio, height: imageHeight / ratio)

        guard let newSizeImage = fixedImage.support.resize(newSize: newSize)?.base,
            let imageData = UIImage.jpegData(newSizeImage)(compressionQuality: 0.8)
            else { return }

        dishImageView.image = newSizeImage
        newImageData = imageData

        NavigationService.dismissTopController()
    }

    func rotateImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        guard let copy = UIGraphicsGetImageFromCurrentImageContext()
            else { return nil }
        UIGraphicsEndImageContext()
        return copy
    }

}
