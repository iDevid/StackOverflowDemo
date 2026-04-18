import Foundation

@Observable
class ErrorPlaceholderViewModel {
    let message: String
    let buttonTitle: String
    let onAction: (() -> Void)?

    init(
        message: String,
        buttonTitle: String,
        onAction: @escaping () -> Void
    ) {
        self.message = message
        self.buttonTitle = buttonTitle
        self.onAction = onAction
    }

    func retryTapped() {
        onAction?()
    }
}
