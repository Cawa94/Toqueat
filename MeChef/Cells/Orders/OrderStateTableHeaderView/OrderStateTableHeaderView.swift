import UIKit

class OrderStateTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var stateLabel: UILabel!

    static var reuseIdentifier = "OrderStateTableHeaderView"

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func configureWith(state: String) {
        stateLabel.text = state.capitalized
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
