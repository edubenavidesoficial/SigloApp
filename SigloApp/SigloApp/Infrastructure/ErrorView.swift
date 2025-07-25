import SwiftUI

enum ErrorType {
    case notFound
    case maintenance
    case connection
    case unexpected
    
    var title: String {
        switch self {
        case .notFound: return "404"
        case .maintenance: return "Servicio no disponible"
        case .connection: return "Error de conexión"
        case .unexpected: return "Ocurrió un error inesperado"
        }
    }
    
    var message: String {
        switch self {
        case .notFound:
            return "Lo sentimos, no podemos encontrar esta página o no está disponible en este momento."
        case .maintenance:
            return "Por motivo de mantenimiento nuestra aplicación no está disponible en este momento, restableceremos su funcionamiento más tarde. Gracias por tu comprensión."
        case .connection:
            return "Por favor revisa tu conexión a internet."
        case .unexpected:
            return "Estamos trabajando para ofrecerte una solución lo más pronto posible."
        }
    }
    
    var icon: String {
        switch self {
        case .notFound: return "exclamationmark.triangle"
        case .maintenance: return "wrench.fill"
        case .connection: return "wifi.exclamationmark"
        case .unexpected: return "xmark.circle"
        }
    }
    
    var buttonText: String {
        self == .connection ? "REGRESAR" : "REINTENTAR"
    }
}

struct ErrorView: View {
    let errorType: ErrorType
    var onRetry: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Imagen de fondo
            Image("siglo")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Icono centrado
                Image(systemName: errorType.icon)
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .padding()
                
                // Título del error
                Text(errorType.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                
                // Mensaje de error
                Text(errorType.message)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                // **Bloque del botón anclado al fondo**
                VStack {
                    Button(action: { onRetry?() }) {
                        Text(errorType.buttonText)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground).opacity(0.8))
        }
        .zIndex(999)
    }
}
