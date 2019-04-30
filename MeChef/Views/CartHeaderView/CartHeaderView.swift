import UIKit
import RxSwift
import Nuke

class CartHeaderView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var chefAvailabilityButton: UIButton!

    var disposeBag = DisposeBag()

    public var availabilityButton: UIButton {
        return chefAvailabilityButton
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("CartHeaderView",
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

    override func awakeFromNib() {
        avatarImageView.roundCorners(radii: self.avatarImageView.frame.width/2,
                                     borderWidth: 2.0, borderColor: .mainOrangeColor)
    }

    func configure(chef: BaseChef) {
        disposeBag = DisposeBag()
        let formattedChefString = NSMutableAttributedString()
        formattedChefString
            .bold("\(chef.name)", size: 16.0)
            .normal(" is gonna be your chef today!", size: 16.0)
        nameLabel.attributedText = formattedChefString
        if let url = chef.avatarLink {
            Nuke.loadImage(with: url, into: avatarImageView)
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.image = UIImage(named: "chef_placeholder")
        }
    }

}
