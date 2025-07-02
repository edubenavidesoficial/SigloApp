import SwiftUI

struct AvisosView: View {
    var body: some View {
        VStack {
           
            Text("Aún no tienes datos")
                .font(.title3)
                .foregroundColor(.gray)

            Text("cargando..")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
