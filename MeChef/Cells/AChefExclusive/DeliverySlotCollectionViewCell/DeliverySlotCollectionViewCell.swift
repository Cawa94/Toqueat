import UIKit

class DeliverySlotCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    static let reuseID = "DeliverySlotCollectionViewCell"

    override func prepareForReuse() {
        self.backgroundColor = .white
        titleLabel.textColor = .darkGrayColor
        roundCorners(radii: 0, borderWidth: 1.5, borderColor: .clear)
        removeDrawnLines()
    }

    func drawBorders(isWeekday: Bool) {
        if isWeekday {
            addLine(position: .bottom, color: .mainOrangeColor, width: 1.5)
        } else {
            roundCorners(radii: 0, borderWidth: 0.5, borderColor: .lightGrayBorderColor)
        }
    }

}
