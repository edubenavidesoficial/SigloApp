import SwiftUI

struct SideMenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 20)

            List {
                MenuRow(title: "La Laguna", icon: "sun.max")
                MenuRow(title: "Meta", icon: "sportscourt")
                MenuRow(title: "Rostros", icon: "face.smiling")
                MenuRow(title: "Economía", icon: "dollarsign.square")
                MenuRow(title: "México y EEUU", icon: "flag")
                MenuRow(title: "El Mundo", icon: "globe")
                MenuRow(title: "Espectáculos", icon: "theatermasks")
                MenuRow(title: "Cultura", icon: "book.closed")
                MenuRow(title: "Laguna Shop", icon: "cart")
                MenuRow(title: "Clasificados", icon: "doc.text")
                MenuRow(title: "Esquelas", icon: "person.text.rectangle")
            }
        }
        .frame(maxWidth: 250)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MenuRow: View {
    var title: String
    var icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30, height: 30)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
    }
}
