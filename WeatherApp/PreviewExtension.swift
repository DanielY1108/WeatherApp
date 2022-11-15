import SwiftUI

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif


// refernce image = "<a href="https://www.flaticon.com/kr/free-icons/" title="지시자 아이콘">지시자 아이콘  제작자: Freepik - Flaticon</a>"
