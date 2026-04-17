import Foundation

struct UserCellViewModel: Identifiable {
    let id: Int
    let name: String
    let reputation: String
    let isFollowed: Bool = Bool.random()

    init(user: StackOverflowUser) {
        self.id = user.id
        self.name = user.name
        self.reputation = Self.formatReputation(user.reputation)
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
