import UIKit

class UserTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UserTableViewCell"

    private let avatarImageView = UIImageView()
    private let avatarImageLoadingIndicator = UIActivityIndicatorView()
    private let nameLabel = UILabel()
    private let reputationBadge = UILabel()
    private let followButton = UIButton()

    private weak var viewModel: UserCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        viewModel = nil
        configureFollowButton(followState: .loading)
        configureImage(.loading)
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .systemGray5

        contentView.addSubview(avatarImageView)

        avatarImageView.addSubview(avatarImageLoadingIndicator)
        avatarImageLoadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.textColor = .label
        contentView.addSubview(nameLabel)

        reputationBadge.translatesAutoresizingMaskIntoConstraints = false
        reputationBadge.font = .systemFont(ofSize: 10, weight: .bold)
        reputationBadge.textColor = .systemBrown
        reputationBadge.backgroundColor = UIColor(red: 0.97, green: 0.94, blue: 0.87, alpha: 1)
        reputationBadge.layer.cornerRadius = 10
        reputationBadge.clipsToBounds = true
        reputationBadge.textAlignment = .center
        contentView.addSubview(reputationBadge)

        followButton.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.foregroundColor = UIColor.white
            outgoing.font = .boldSystemFont(ofSize: 10)
            return outgoing
        }
        configuration.preferredSymbolConfigurationForImage = .init(pointSize: 10)
        followButton.configuration = configuration
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
        contentView.addSubview(followButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),

            avatarImageLoadingIndicator.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            avatarImageLoadingIndicator.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -8),

            reputationBadge.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            reputationBadge.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            reputationBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            reputationBadge.heightAnchor.constraint(equalToConstant: 24),

            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            followButton.heightAnchor.constraint(equalToConstant: 24),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),
        ])
    }

    func configure(with viewModel: UserCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        reputationBadge.text = viewModel.reputation
        setNeedsUpdateProperties()
    }

    override func updateProperties() {
        super.updateProperties()
        guard let viewModel else { return }
        configureImage(viewModel.image)
        configureFollowButton(followState: viewModel.followState)
    }

    @objc
    private func followButtonTapped() {
        Task { try await viewModel?.toggleFollow() }
    }

    private func configureImage(_ imageState: AsyncImageState) {
        imageState == .loading
            ? avatarImageLoadingIndicator.startAnimating()
            : avatarImageLoadingIndicator.stopAnimating()
        switch imageState {
        case .placeholder:
            avatarImageView.image = nil
        case .loading:
            avatarImageView.image = nil
        case .available(let image):
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.image = image
        case .notAvailable:
            avatarImageView.contentMode = .center
            avatarImageView.image = UIImage(systemName: "person")
        }
    }

    private func configureFollowButton(followState: AsyncFollowState) {
        let imageName: String = switch followState {
            case .error:
                "questionmark.circle.dashed"
            case .following:
                "checkmark"
            case .notFollowing:
                "plus"
            case .loading:
                ""
        }
        let image = UIImage(systemName: imageName)
        let title: String = switch followState {
        case .error:
            "N/A"
        case .following:
            "Following"
        case .notFollowing:
            "Follow"
        case .loading:
            ""
        }
        followButton.configuration?.showsActivityIndicator = followState == .loading
        followButton.setTitle(title, for: .normal)
        followButton.setImage(image, for: .normal)
        followButton.tintColor = followState == .following ? .systemBlue : .systemGray2
    }
}
