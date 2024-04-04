import SwiftUI

struct ContainerBackgroundForWidgetModifier<Background>: ViewModifier where Background: View {
    let background: () -> Background
    
    func body(content: Content) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            content
                .containerBackground(for: .widget) {
                    background()
                }
        } else {
            ZStack {
                background()
                content
                    .padding()
            }
        }
    }
}
