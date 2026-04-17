import UIKit

class UserTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UserTableViewCell"

    private let avatarImageView = UIImageView()
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
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .systemGray5

        contentView.addSubview(avatarImageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
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
        configuration.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        configuration.cornerStyle = .capsule
        followButton.configuration = configuration
        followButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        contentView.addSubview(followButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -8),

            reputationBadge.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            reputationBadge.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            reputationBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            reputationBadge.heightAnchor.constraint(equalToConstant: 24),

            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            followButton.heightAnchor.constraint(equalToConstant: 32),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 72),
        ])
    }

    func configure(with viewModel: UserCellViewModel) {
        nameLabel.text = viewModel.name
        reputationBadge.text = viewModel.reputation
        configureFollowButton(isFollowed: viewModel.isFollowed)
        self.viewModel = viewModel
    }

    override func updateProperties() {
        guard let viewModel else { return }
        configureImage(viewModel.image)
    }

    private func configureImage(_ imageState: AsyncImageState) {
        switch imageState {
        case .placeholder:
            avatarImageView.image = nil
        case .loading:
            avatarImageView.image = nil
        case .available(let image):
            avatarImageView.image = image
        case .notAvailable:
            avatarImageView.image = UIImage(systemName: "person")
        }
    }

    private func configureFollowButton(isFollowed: Bool) {
        if isFollowed {
            followButton.setTitle("Following", for: .normal)
            followButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
    }
}
