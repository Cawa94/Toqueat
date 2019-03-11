import UIKit
import RxSwift
import Nuke

class DishViewController: BaseStatefulController<Dish> {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!

    var dishViewModel: DishViewModel! {
        didSet {
            viewModel = dishViewModel
        }
    }

    private let disposeBag = DisposeBag()

    @IBAction func addToCartAction(_ sender: Any) {
        CartService.addToCart(product: BaseResultWithIdAndName(id: dishViewModel.result.id,
                                                               name: dishViewModel.result.name))
        debugPrint("CART PRODUCTS: \(CartService.localCart?.products.map { $0.name } ?? ["Unknown"])")
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
