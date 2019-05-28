import UIKit
import RxSwift
import Nuke

class CartHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        avatarImageView.roundCorners(radii: self.avatarImageView.frame.width/2,
                                     borderWidth: 2.0, borderColor: .mainOrangeColor)
    }

    func configure(chef: BaseChef) {
        let formattedChefString = NSMutableAttributedString()
        formattedChefString
            .bold("\(chef.name)", size: 16.0)
            .normal(" is gonna cook this dishes for you!", size: 16.0)
        nameLabel.attributedText = formattedChefString
        if let url = chef.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
        } else {
            avatarImageView.image = UIImage(named: "chef_placeholder")
        }
        avatarImageView.contentMode = .scaleAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
