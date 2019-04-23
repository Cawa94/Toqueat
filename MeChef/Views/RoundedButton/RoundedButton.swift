import UIKit
import LeadKit

final class RoundedButton: UIButton {

    struct Appearance {
        var backgoundColor: UIColor
        var borderColor: UIColor
        var borderWidth: CGFloat
        var height: CGFloat
        var align: UIControl.ContentHorizontalAlignment
        var cornerRadius: CGFloat
    }

    fileprivate enum ButtonState {
        case controlState(state: UIControl.State)
        case loading
    }

    enum LoadingIndicatorPosition {
        case beforeText
        case afterText
        case center
    }

    private typealias LoadingIndicatorSettings = (indicator: UIActivityIndicatorView,
        position: LoadingIndicatorPosition)
    private var heightConstant: CGFloat?
    private var loadingIndicatorSettings: LoadingIndicatorSettings?
    private var viewModel: RoundedButtonViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override var intrinsicContentSize: CGSize {
        let superIntrinsicContentSize = super.intrinsicContentSize
        let titleSize = titleLabel?.intrinsicContentSize

        guard let heightConstant = heightConstant, let widthConstant = titleSize?.width
            else { return superIntrinsicContentSize }

        let width = 15 + widthConstant + 15

        return CGSize(width: width, height: heightConstant)
    }

    func configure(loadingIndicator: UIActivityIndicatorView, at position: LoadingIndicatorPosition) {
        loadingIndicatorSettings?.indicator.removeFromSuperview()
        addIndicator(settings: LoadingIndicatorSettings(loadingIndicator, position))
    }

    // MARK: - Actions

    @objc private func touchDownEvent(_ sender: RoundedButton) {
        guard let viewModel = viewModel else {
            return
        }

        let appearance = viewModel.type.appearance(for: viewModel.state(for: .highlighted))
        configure(appearance: appearance)
    }

    @objc private func touchUpEvent(_ sender: RoundedButton) {
        guard let viewModel = viewModel else {
            return
        }

        let appearance = viewModel.type.appearance(for: viewModel.state(for: .normal))
        configure(appearance: appearance)
    }

    // MARK: - Private stuff

    private func configure() {
        layer.masksToBounds = true

        configure(appearance: RoundedButtonType.defaultOrange.appearance(for: .controlState(state: .normal)))

        addTarget(self, action: #selector(touchDownEvent(_:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpEvent(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpEvent(_:)), for: .touchUpOutside)
    }

    private func addIndicator(settings: LoadingIndicatorSettings) {
        loadingIndicatorSettings = settings

        settings.indicator.translatesAutoresizingMaskIntoConstraints = false
        settings.indicator.hidesWhenStopped = true

        addSubview(settings.indicator)

        switch settings.position {
        case .beforeText:
            let horizontalConstraint = NSLayoutConstraint(item: settings.indicator,
                                                          attribute: NSLayoutConstraint.Attribute.leading,
                                                          relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                                                          attribute: NSLayoutConstraint.Attribute.leading,
                                                          multiplier: 1, constant: 20)
            let centerYConstraint = settings.indicator.centerYAnchor.constraint(equalTo: centerYAnchor)

            NSLayoutConstraint.activate([horizontalConstraint, centerYConstraint])
        case .afterText:
            let horizontalConstraint = NSLayoutConstraint(item: settings.indicator,
                                                          attribute: NSLayoutConstraint.Attribute.trailing,
                                                          relatedBy: NSLayoutConstraint.Relation.equal, toItem: self,
                                                          attribute: NSLayoutConstraint.Attribute.trailing,
                                                          multiplier: 1, constant: -20)
            let centerYConstraint = settings.indicator.centerYAnchor.constraint(equalTo: centerYAnchor)

            NSLayoutConstraint.activate([horizontalConstraint, centerYConstraint])
        case .center:
            let centerXConstraint = settings.indicator.centerXAnchor.constraint(equalTo: centerXAnchor)
            let centerYConstraint = settings.indicator.centerYAnchor.constraint(equalTo: centerYAnchor)

            NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        }

        setIndicator(visible: false)
    }

    private func setIndicator(visible: Bool) {
        guard let settings = loadingIndicatorSettings else {
            return
        }

        visible ? settings.indicator.startAnimating() : settings.indicator.stopAnimating()

        isEnabled = !visible
    }

}

extension RoundedButton: ConfigurableView {

    func configure(with viewModel: RoundedButtonViewModel) {
        self.viewModel = viewModel

        let states: [UIControl.State] = [.normal, .highlighted, .disabled]

        states.forEach { setTitle(nil, for: $0) }
        states.forEach { setAttributedTitle(viewModel.attributedTitle, for: $0) }

        configure(appearance: viewModel.type.appearance(for: viewModel.state(for: .normal)))

        setIndicator(visible: viewModel.loadingState)
    }

}

extension RoundedButton: AppearanceConfigurable {

    func configure(appearance: RoundedButton.Appearance) {
        backgroundColor = appearance.backgoundColor

        layer.borderColor = appearance.borderColor.cgColor
        layer.borderWidth = appearance.borderWidth
        layer.cornerRadius = appearance.cornerRadius == 45 ? 20 : appearance.cornerRadius

        contentHorizontalAlignment = appearance.align

        heightConstant = appearance.height
    }

}

private extension RoundedButtonViewModel {

    func state(for controlState: UIControl.State) -> RoundedButton.ButtonState {
        return loadingState ? .loading : .controlState(state: controlState)
    }

}

private extension RoundedButtonType {

    func appearance(for state: RoundedButton.ButtonState) -> RoundedButton.Appearance {
        switch self {
        case .defaultOrange:
            return state.orangeButtonAppearance(height: 40)
        case .squeezedOrange:
            return .init(backgroundColor: .mainOrangeColor,
                         height: 40, cornerRadius: 45)
        case .squeezedWhite:
            return .init(backgroundColor: .white, borderColor: .mainOrangeColor,
                         height: 40, cornerRadius: 45)
        }
    }

}

private extension RoundedButton.ButtonState {

    func orangeButtonAppearance(height: CGFloat) -> RoundedButton.Appearance {
        let backgroundColor: UIColor

        switch self {
        case .controlState(let state):
            switch state {
            case .normal:
                backgroundColor = .mainOrangeColor
            case .highlighted, .disabled:
                backgroundColor = .highlightedOrangeColor
            default:
                backgroundColor = .mainOrangeColor
            }
        case .loading:
            backgroundColor = .mainOrangeColor
        }

        return .init(backgroundColor: backgroundColor, height: height)
    }

}

private extension RoundedButton.Appearance {

    init(backgroundColor: UIColor = .mainOrangeColor,
         borderColor: UIColor = .clear,
         borderWidth: CGFloat = 1,
         height: CGFloat = 36,
         align: UIControl.ContentHorizontalAlignment = .center,
         cornerRadius: CGFloat = 5) {

        self.init(backgoundColor: backgroundColor,
                  borderColor: borderColor,
                  borderWidth: borderWidth,
                  height: height,
                  align: align,
                  cornerRadius: cornerRadius)
    }

}
