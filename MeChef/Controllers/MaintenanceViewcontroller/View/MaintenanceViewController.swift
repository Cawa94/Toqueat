import UIKit
import SwiftyGif

class MaintenanceViewController: UIViewController {

    @IBOutlet private weak var workingImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        workingImageView.setGifImage(UIImage(gifName: "monkey"))
        workingImageView.startAnimatingGif()
    }

}
