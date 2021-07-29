import Foundation

// MARK: - SwiftUI Preview –

import SwiftUI

@available(iOS 13.0.0, *)
struct ForecastListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ForecastListProvider.ContainterView>) -> MainNavigationController {
            let wireframe = SplashScreenWireframe()
            let root = MainNavigationController()
            root.setRootWireframe(wireframe)
            return root
        }
        
        func updateUIViewController(_ uiViewController: ForecastListProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ForecastListProvider.ContainterView>) {
            
        }
    }
}
