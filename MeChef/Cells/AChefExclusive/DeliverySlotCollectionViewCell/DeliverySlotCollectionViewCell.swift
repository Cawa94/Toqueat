import UIKit

class DeliverySlotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    static let reuseID = "DeliverySlotCollectionViewCell"

    override func prepareForReuse() {
        self.backgroundColor = .white
    }

}
