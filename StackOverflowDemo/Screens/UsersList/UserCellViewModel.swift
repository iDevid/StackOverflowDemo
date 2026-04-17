import Foundation
import ImageLoader
import UIKit

enum AsyncImageState {
    case placeholder
    case loading
    case available(UIImage)
    case notAvailable
}

@Observable
class UserCellViewModel: Identifiable {
    let id: Int
    let name: String
    let reputation: String
    let isFollowed: Bool = Bool.random()
    var image: AsyncImageState

    private let imageUrlString: String

    init(user: StackOverflowUser) {
        self.id = user.id
        self.name = user.name
        self.reputation = Self.formatReputation(user.reputation)
        self.image = .placeholder
        self.imageUrlString = user.image
    }

    func loadImage(_ loader: ImageLoading) {
        Task {
            image = .loading
            do {
                let uiImage = try await loader.loadImage(
                    from: imageUrlString,
                    cachePolicy: .returnCacheDataElseLoad
                )
                self.image = .available(uiImage)
            } catch {
                self.image = .notAvailable
            }
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
