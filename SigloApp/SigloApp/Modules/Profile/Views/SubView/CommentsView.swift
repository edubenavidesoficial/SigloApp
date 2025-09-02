import SwiftUI

struct CommentsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ciclón John toca tierra por segunda vez, ahora en Michoacán; ha dejado al menos 16 muertos")
                .font(.headline)
                .lineLimit(nil)

            HStack(alignment: .top) {
                Text("Lo peor de todo es que se espera que otro huracán toque tierra en las costas de Guerrero.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(nil)

                Spacer()

                Text("09:13 am, hoy")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
