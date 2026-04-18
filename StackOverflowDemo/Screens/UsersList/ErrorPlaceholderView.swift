import UIKit

class ErrorPlaceholderView: UIView {

    private let label = UILabel()
    private let button = UIButton(type: .system)

    private weak var viewModel: ErrorPlaceholderViewModel?

    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateProperties() {
        guard let viewModel else { return }
        label.text = viewModel.message
        button.setTitle(viewModel.buttonTitle, for: .normal)
    }

    public func update(with viewModel: ErrorPlaceholderViewModel?) {
        self.viewModel = viewModel
        updateProperties()
    }

    private func setupUI() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        let symbol = UIImage(systemName: "wifi.exclamationmark")!
        let symbolView = UIImageView(image: symbol)
        symbolView.contentMode = .scaleAspectFit
        symbolView.addSymbolEffect(
            .wiggle.byLayer,
            options: .repeat(.periodic(delay: 1))
        )
        stack.addArrangedSubview(symbolView)

        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        stack.addArrangedSubview(label)

        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.cornerStyle = .capsule
        configuration.image = UIImage(systemName: "arrow.counterclockwise")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 10)
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = .boldSystemFont(ofSize: 15)
            return outgoing
        }
        button.configuration = configuration
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        stack.addArrangedSubview(button)

        NSLayoutConstraint.activate([
            symbolView.heightAnchor.constraint(equalToConstant: 100),
            symbolView.widthAnchor.constraint(equalToConstant: 100),

            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    @objc
    private func retryButtonTapped() {
        viewModel?.retryTapped()
    }
}
