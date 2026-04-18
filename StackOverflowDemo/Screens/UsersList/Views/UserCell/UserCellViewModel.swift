import Foundation
import ImageLoader
import PersistenceLayer
import UIKit

enum AsyncImageState: Equatable {
    case placeholder
    case loading
    case available(UIImage)
    case notAvailable

    var isAvailableOrLoading: Bool {
        switch self {
        case .available, .loading:
            return true
        default:
            return false
        }
    }
}

enum AsyncFollowState {
    case error
    case following
    case notFollowing
    case loading
}

@Observable
class UserCellViewModel: Identifiable {
    let id: Int
    let name: String
    let reputation: String
    var followState: AsyncFollowState
    var image: AsyncImageState

    private let imageUrlString: String
    private let followUserRepository: FollowedUserRepository
    private var imageLoadTask: Task<Void, Never>?

    init(user: StackOverflowUser, followUserRepository: FollowedUserRepository) {
        self.id = user.id
        self.name = user.name
        self.reputation = Self.formatReputation(user.reputation)
        self.image = .placeholder
        self.imageUrlString = user.image
        self.followUserRepository = followUserRepository
        self.followState = .loading

        Task {
            do {
                let isFollowed = try await followUserRepository.isFollowed(userId: user.id)
                self.followState = isFollowed ? .following : .notFollowing
            } catch {
                self.followState = .error
            }
        }
    }

    func loadImageIfNeeded(_ loader: ImageLoading) {
        guard !image.isAvailableOrLoading else { return }
        imageLoadTask?.cancel()
        image = .loading
        imageLoadTask = Task {
            do {
                let uiImage = try await loader.loadImage(
                    from: imageUrlString,
                    cachePolicy: .returnCacheDataElseLoad
                )
                self.image = .available(uiImage)
            } catch {
                guard !Task.isCancelled else { return }
                print("Error Loading Image for: \(self.name)")
                self.image = .notAvailable
            }
        }
    }

    func toggleFollow() async throws {
        let previousState = followState
        let shouldFollow = previousState == .notFollowing
        do {
            followState = .loading
            try await followUserRepository.setFollowed(shouldFollow, userId: id)
            followState = shouldFollow ? .following : .notFollowing
        } catch let error {
            followState = previousState
            throw error
        }
    }

    private static func formatReputation(_ reputation: Int) -> String {
        switch reputation {
        case 1_000_000...:
            let millions = Double(reputation) / 1_000_000
            return String(format: "%.1f", millions) + "m"
        case 1_000...:
            return "\(reputation / 1_000)k"
        default:
            return "\(reputation)"
        }
    }
}

extension UserCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension UserCellViewModel: Equatable {
    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
