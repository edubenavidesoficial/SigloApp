import SwiftUI
import UIKit

struct HTMLTextView: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        guard let data = html.data(using: .utf16) else {
            uiView.text = html
            return
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: .html,
            .characterEncoding: String.Encoding.utf16.rawValue
        ]

        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            uiView.attributedText = attributedString
        } else {
            uiView.text = html
        }
    }
}
