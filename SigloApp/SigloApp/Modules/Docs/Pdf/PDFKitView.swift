import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        // Fondo negro
        pdfView.backgroundColor = .black
        pdfView.usePageViewController(true, withViewOptions: nil)
        pdfView.displayBox = .cropBox
        pdfView.isUserInteractionEnabled = true
        pdfView.isHidden = false
        
        // Ocultar la barra de herramientas si aparece algo por defecto
        pdfView.subviews.forEach { subview in
            if subview is UIToolbar {
                subview.isHidden = true
            }
        }
        
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.backgroundColor = .black
    }
}
