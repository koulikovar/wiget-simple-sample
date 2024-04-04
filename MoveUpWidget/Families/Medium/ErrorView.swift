import SwiftUI

extension MoveUpWidgetMediumView {
    struct ErrorView: View {
        // MARK: - Private
        
        @Environment(\.colorScheme) private var colorScheme
        
        private let errorMessage: LocalizedStringKey
        
        // MARK: - Lifecycle
        
        init(errorMessage: LocalizedStringKey) {
            self.errorMessage = errorMessage
        }
        
        // MARK: - Body
        
        var body: some View {
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .font(Typography.link)
                .foregroundColor(Color("counterPrimary"))
            .containerBackgroundForWidget {
                Color("mediumWidgetBackground")
                    .environment(\.colorScheme, self.colorScheme)
            }
        }
    }
}
