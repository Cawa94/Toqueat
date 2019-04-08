import UIKit
import RxSwift
import RxCocoa

struct DishType {
    var imageName: String
    var name: String
    var sortParams: [String]
    var isActive: Bool

    init(imageName: String,
         name: String,
         sortParams: [String],
         isActive: Bool = false) {
        self.imageName = imageName
        self.name = name
        self.sortParams = sortParams
        self.isActive = isActive
    }

    static let activePopularOption = DishType(imageName: "sort_popular",
                                              name: "Popular",
                                              sortParams: ["editorial_best"],
                                              isActive: true)
}

class DishTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func configureWith(_ dishType: DishType) {
        nameLabel.text = dishType.name
        imageView.image = UIImage(named: dishType.imageName)
    }

}
