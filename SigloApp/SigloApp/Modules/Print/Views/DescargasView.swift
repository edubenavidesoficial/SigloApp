import SwiftUI

struct DescargasView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray.and.arrow.down.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.red)
                .padding()

            Text("Aún no tienes descargas")
                .font(.title3)
                .foregroundColor(.gray)

            Text("Aquí aparecerá lo que descargues")
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
    }
}
