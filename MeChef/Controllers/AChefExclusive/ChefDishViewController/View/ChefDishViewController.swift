import UIKit
import RxSwift
import Nuke

class ChefDishViewController: UIViewController,
    UITextViewDelegate {

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

    var placeholderLabel: UILabel!
    var viewModel: ChefDishViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureXibElements()
        populateXibElements()
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .mainOrangeColor
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.mainOrangeColor]
        navigationController?.isNavigationBarHidden = false
        title = viewModel.dish != nil ? "Edit dish" : "New dish"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveAndClose))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissDish))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @objc func dismissDish() {
        NavigationService.popNavigationTopController()
    }

    @objc func saveAndClose() {
        guard let name = nameTextField.text,
            /*let type = typeTextField.text, let servings = servingsTextField.text,
            let ingredients = ingredientsTextField.text, */let description = descriptionTextView.text,
            let priceText = priceTextField.text
            else { return }
        let price = NSDecimalNumber(string: "\(priceText.doubleValue)")
        let dishParameters = DishCreateParameters(name: name, description: description,
                                                  price: price, chefId: "\(viewModel.chefId)")
        if let dish = viewModel.dish {
            NetworkService.shared.updateDishWith(parameters: dishParameters, dishId: dish.id)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { _ in
                    self.presentAlertWith(title: "YEAH", message: "Dish updated",
                                          actions: [ UIAlertAction(title: "Ok", style: .default, handler: { _ in
                                            NavigationService.reloadChefDishes = true
                                            NavigationService.popNavigationTopController()
                                          })])
                }, onError: { _ in })
                .disposed(by: disposeBag)
        } else {
            NetworkService.shared.createNewDishWith(parameters: dishParameters)
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { _ in
                    self.presentAlertWith(title: "YEAH", message: "Dish created",
                        actions: [ UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            NavigationService.reloadChefDishes = true
                            NavigationService.popNavigationTopController()
                        })])
                }, onError: { _ in })
                .disposed(by: disposeBag)
        }
    }

    func configureXibElements() {
        dishImageView.roundCorners(radii: 15.0)
        nameTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        priceTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        typeTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        servingsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        ingredientsTextField.addLine(position: .bottom, color: .lightGray, width: 0.5)
        descriptionTextView.addLine(position: .bottom, color: .lightGray, width: 0.5)

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
        if let dish = viewModel.dish {
            // Editing dish
            if let imageUrl = dish.imageLink {
                cameraButton.isHidden = true
                Nuke.loadImage(with: imageUrl, into: dishImageView)
                dishImageView.contentMode = .scaleAspectFill
            }
            nameTextField.text = dish.name
            priceTextField.text = "\(dish.price)"
            typeTextField.text = "Main course"
            servingsTextField.text = "2"
            descriptionTextView.text = dish.description
            placeholderLabel.isHidden = true
        } else {
            // New dish
        }
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

}
