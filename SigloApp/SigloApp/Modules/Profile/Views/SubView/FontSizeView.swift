import SwiftUI

struct FontSizeView: View {
    @State private var fontSize: Double = 1.0

    var body: some View {
        VStack(alignment: .leading) {
            Text("TAMAÑO DE LETRA")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Para su comodidad de lectura puede personalizar el tamaño de la fuente en las notas.")
                .font(.caption)
                .foregroundColor(.gray)

            HStack(alignment: .top){
                Text("Aa")
                    .font(.system(size: 14))

                Slider(value: $fontSize, in: 0.5...2.0, step: 0.1)
                    .accentColor(.blue)

                Text("Aa")
                    .font(.system(size: 24))
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
