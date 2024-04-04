import SwiftUI

extension View {
    func containerBackgroundForWidget<Background>(
        @ViewBuilder background: @escaping () -> Background
    ) -> some View where Background: View {
        modifier(ContainerBackgroundForWidgetModifier(background: background))
    }
}
