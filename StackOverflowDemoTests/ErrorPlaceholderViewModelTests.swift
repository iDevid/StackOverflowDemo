import Testing
import UIKit

@testable import StackOverflowDemo

@Suite final class ErrorPlaceholderViewModelTests {

    @Test func retryTappedCallsOnAction() {
        var actionCalled = false
        let sut = ErrorPlaceholderViewModel(
            message: "Error",
            buttonTitle: "Retry",
            onAction: {
                actionCalled = true
            }
        )

        sut.retryTapped()

        #expect(actionCalled)
    }
}
