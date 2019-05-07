import UIKit
import RxSwift
import Nuke
import SwiftValidator

private extension CGFloat {
    static let maxAvatarDimension: CGFloat = 1_080
}

class ChefDishViewController: BaseStatefulController<Dish>,
    UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dishImageView: UIImageView!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var typeTextField: UITextField!
    @IBOutlet private weak var servingsTextField: UITextField!
    @IBOutlet private weak var ingredientsTextField: UITextField!
    @IBOutlet private weak var descriptionTextView: UITextView!

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
        title = chefDishViewModel.isNewDish ? "New dish" : "Edit dish"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(save))
    }

    @objc func save() {
        validator.validate(self)
    }

    func configureXibElements() {
        dishImageView.roundCorners(radii: 15.0)
        dishImageView.rx.tapGesture().when(.recognized).asDriver()
            .drive(onNext: { _ in
                self.pickImageAction()
            }).disposed(by: disposeBag)
        nameTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        priceTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        typeTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        servingsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        ingredientsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        descriptionTextView.addLine(position: .bottom, color: .lightGray, width: 0.5)

        typeTextField.inputView = typePicker
        typePicker.delegate = self

        placeholderLabel = UILabel()
        placeholderLabel.text = "Describe your dish..."
        placeholderLabel.font = UIFont.regularFontOf(size: 16.0)
        placeholderLabel.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }

    func populateXibElements() {
        if !chefDishViewModel.isNewDish {
            let dish = chefDishViewModel.result
            // Editing dish
            if let imageUrl = dish.imageLink {
                Nuke.loadImage(with: imageUrl, into: dishImageView)
                dishImageView.contentMode = .scaleAspectFill
            }
            nameTextField.text = dish.name
            priceTextField.text = dish.price.stringWithoutCurrency
            typeTextField.text = dish.categories?.first?.name
            servingsTextField.text = "\(dish.servings ?? 1)"
            ingredientsTextField.text = dish.ingredients
            descriptionTextView.text = dish.description
            placeholderLabel.isHidden = true
        } else {
            // New dish
        }
    }

    func addValidationRules() {
        validator.registerField(nameTextField, rules: [RequiredRule()])
        validator.registerField(priceTextField, rules: [RequiredRule()])
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
    }

    func pickImageAction() {
        ImagePickerManager().pickImage(self) { image in
            self.didPick(image: image)
        }
    }

    func didPick(image: UIImage?) {
        guard let image = image, let fixedImage = rotateImage(image: image)
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
    }

}

extension ChefDishViewController: ValidationDelegate {

    func validationSuccessful() {
        guard let name = nameTextField.text,
            let categoryId = DishCategoryType.allValues.first(where: { $0.name == typeTextField.text })?.id,
            let servings = servingsTextField.text,
            let description = descriptionTextView.text,
            let priceText = priceTextField.text,
            let chefId = SessionService.session?.chef?.id
            else { return }
        let price = NSDecimalNumber(string: "\(priceText.doubleValue)")
        let ingredients = ingredientsTextField.text
        let dishParameters = DishCreateParameters(name: name, description: description,
                                                  price: price, chefId: "\(chefId)",
                                                  categoryIds: [categoryId], ingredients: ingredients,
                                                  servings: Int(servings) ?? 1)
        var operationSingle: Single<Void>
        if !chefDishViewModel.isNewDish {
            let updateDishSingle = NetworkService.shared.updateDishWith(parameters: dishParameters,
                                                                        dishId: chefDishViewModel.result.id)
                .map { _ in
                    if let newImage = self.newImageData {
                        NetworkService.shared.uploadDishPicture(for: self.chefDishViewModel.result.id,
                                                                imageData: newImage,
                                                                completion: { _ in })
                    }
            }
            operationSingle = updateDishSingle
        } else {
            let createDishSingle = NetworkService.shared.createNewDishWith(parameters: dishParameters)
                .map { dish in
                    if let newImage = self.newImageData {
                        NetworkService.shared.uploadDishPicture(for: dish.id,
                                                                imageData: newImage,
                                                                completion: { _ in })
                    }
            }
            operationSingle = createDishSingle
        }
        hudOperationWithSingle(operationSingle: operationSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: "YEAH", message: "Dish updated",
                                    actions: [ UIAlertAction(title: "Ok", style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadChefDishes = true
                                    })])
        }, disposeBag: disposeBag)
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
