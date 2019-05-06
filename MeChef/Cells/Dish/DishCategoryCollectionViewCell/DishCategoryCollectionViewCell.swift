import UIKit
import RxSwift
import RxCocoa

class DishCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    var disposeBag = DisposeBag()
    var paramId: Int64?

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configureWith(_ dishCategory: DishCategory) {
        nameLabel.text = dishCategory.name
        let imageName = dishCategory.isActive
            ? "\(dishCategory.imageName)_selected" : dishCategory.imageName
        imageView.image = UIImage(named: imageName)
        paramId = dishCategory.paramId
    }

}
