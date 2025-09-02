import SwiftUI
import WebKit

struct HTMLWebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        // ✅ Scroll habilitado
        webView.scrollView.isScrollEnabled = true

        // ✅ Oculta los indicadores de scroll (vertical y horizontal)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false

        // ✅ Fondo transparente para que se mezcle con SwiftUI
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear

        // Delegado opcional
        webView.navigationDelegate = context.coordinator

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let styledHTML = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, sans-serif;
                    font-size: 16px;
                    color: #222222;
                    line-height: 1.6;
                    margin: 0 10px;
                    padding: 0;
                    word-wrap: break-word;
                }
                h1, h2, h3, h4 {
                    font-weight: bold;
                    color: #111111;
                    margin: 16px 0 8px;
                }
                p {
                    margin-bottom: 12px;
                }
                img {
                    max-width: 100%;
                    height: auto;
                    display: block;
                    margin: 12px auto;
                    border-radius: 8px;
                }
                ul, ol {
                    padding-left: 18px;
                    margin-bottom: 12px;
                }
                li {
                    margin-bottom: 8px;
                }
                a {
                    color: #007AFF;
                    text-decoration: none;
                    word-break: break-word;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    overflow-x: auto;
                    display: block;
                }
                th, td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    font-size: 14px;
                }
                blockquote {
                    border-left: 4px solid #ccc;
                    padding-left: 12px;
                    color: #666;
                    margin: 12px 0;
                }
            </style>
        </head>
        <body>
            \(htmlContent)
        </body>
        </html>
        """

        webView.loadHTMLString(styledHTML, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        // Puedes manejar navegación aquí si quieres
    }
}


