import SwiftUI

struct OpenView: View {
    @State private var navigateToHome = false // Estado para controlar la navegación
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo blanco
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                // Imagen en el centro
                Image("inicio") // Asegúrate de tener la imagen llamada "llama" en tus recursos
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .onAppear {
                // Temporizador que cambia a HomeView después de 8 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    self.navigateToHome = true
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView() // Vista de destino cuando el estado cambia
            }
        }
    }
}
