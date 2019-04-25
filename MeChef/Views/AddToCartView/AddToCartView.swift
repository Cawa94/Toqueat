import UIKit

final class AddToCartView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addToBasketView: UIView!
    @IBOutlet private weak var addToBasketButton: RoundedButton!
    @IBOutlet private weak var quantityControllerView: UIView!
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var addOneButton: UIButton!
    @IBOutlet private weak var removeOneButton: UIButton!

    public var addButton: UIButton {
        return addToBasketButton
    }

    public var addOne: UIButton {
        return addOneButton
    }

    public var removeOne: UIButton {
        return removeOneButton
    }

    private var viewModel: AddToCartViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("AddToCartView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func configureWith(_ viewModel: AddToCartViewModel) {
        self.viewModel = viewModel

        if !viewModel.isInCart {
            // not in cart
            addToBasketView.isHidden = false
            quantityControllerView.isHidden = true
            let addToCartModel = RoundedButtonViewModel(title: "", type: .defaultOrange)
            addToBasketButton.configure(with: addToCartModel)
            priceLabel.text = "€\(viewModel.dish.price)"
        } else {
            // in cart
            addToBasketView.isHidden = true
            quantityControllerView.isHidden = false
            quantityLabel.text = "x \(viewModel.quantityInCart) -"
                + " €\(viewModel.dish.price.multiplying(by: NSDecimalNumber(value: viewModel.quantityInCart)))"
            addOneButton.roundCorners(radii: 10)
            removeOneButton.roundCorners(radii: 10)
        }
    }

}
