import UIKit
import RxSwift
import Nuke

class DishViewController: BaseStatefulController<Dish> {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var openCartButton: UIButton!
    @IBOutlet weak var removeFromCartButton: UIButton!

    var dishViewModel: DishViewModel! {
        didSet {
            viewModel = dishViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        CartService.localCartDriver
            .map { $0?.dishes?.isEmpty ?? true }
            .drive(self.openCartButton.rx.isHidden)
            .disposed(by: disposeBag)

        CartService.localCartDriver
            .map { !($0?.dishes?.contains(where: { $0.id == self.dishViewModel.dishId }) ?? false) }
            .drive(self.removeFromCartButton.rx.isHidden)
            .disposed(by: disposeBag)
    }

    // MARK: - Actions

    @IBAction func addToCartAction(_ sender: Any) {
        if let currentChef = CartService.localCart?.chefId, currentChef != dishViewModel.chefId {
            presentAlertWith(title: "WARNING", message: "You're gonna lose all your products",
                             actions: [UIAlertAction(title: "Proceed", style: .default, handler: { _ in
                                CartService.clearCart()
                                CartService.addToCart(self.dishViewModel.localCartDish,
                                                      chefId: self.dishViewModel.chefId)
                             }),
                                       UIAlertAction(title: "Cancel", style: .cancel, handler: nil)])
            return
        }
        CartService.addToCart(dishViewModel.localCartDish, chefId: dishViewModel.chefId)
    }

    @IBAction func removeFromCartAction(_ sender: Any) {
        CartService.removeFromCart(dishViewModel.localCartDish)
    }

    @IBAction func showChefAvailabilityAction(_ sender: Any) {
        NavigationService.pushChefDeliverySlotsViewController(chefId: dishViewModel.chefId)
    }

    @IBAction func openCartAction(_ sender: Any) {
        guard let cart = CartService.localCart
            else { return }
        NavigationService.pushCartViewController(cart: cart)
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        nameLabel.text = dishViewModel.dishName
        descriptionLabel.text = dishViewModel.dishDescription
        chefNameLabel.text = "Chef: \(dishViewModel.chefName)"
        if let imageUrl = dishViewModel.imageUrl {
            Nuke.loadImage(with: imageUrl, into: dishImageView)
            dishImageView.contentMode = .scaleAspectFill
        }
    }

    override func onLoadingState() {
        nameLabel.text = dishViewModel.dishName
        descriptionLabel.text = dishViewModel.dishDescription
        chefNameLabel.text = "Chef: \(dishViewModel.chefName)"
    }

}
