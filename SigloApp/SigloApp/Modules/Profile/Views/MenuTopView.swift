import SwiftUI

struct MenuTopView: View {
    @State private var activeSections = ["EDITORIALES", "SIGLO TV", "FOTOS", "MÁS VISTO", "MINUTO A MINUTO", "DEPORTES", "FINANZAS", "LA LAGUNA"]
    @State private var inactiveSections = ["GÓMEZ PALACIO Y LERDO", "ROSTROS", "EL MUNDO"]
    @State private var isEditable = true

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Toggle(isOn: $isEditable) {
                    VStack(alignment: .leading) {
                        Text("Menú superior")
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Personalice el orden de las secciones a mostrar")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(activeSections, id: \.self) { item in
                            SectionRow(title: item, isActive: true, onToggle: {
                                moveToInactive(item: item)
                            })
                            .onDrag {
                                return NSItemProvider(object: item as NSString)
                            }
                        }

                        Divider().padding(.vertical)

                        ForEach(inactiveSections, id: \.self) { item in
                            SectionRow(title: item, isActive: false, onToggle: {
                                moveToActive(item: item)
                            })
                            .onDrag {
                                return NSItemProvider(object: item as NSString)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // Mover a inactivo
    func moveToInactive(item: String) {
        if let index = activeSections.firstIndex(of: item) {
            activeSections.remove(at: index)
            inactiveSections.append(item)
        }
    }

    // Mover a activo
    func moveToActive(item: String) {
        if let index = inactiveSections.firstIndex(of: item) {
            inactiveSections.remove(at: index)
            activeSections.append(item)
        }
    }
}

struct SectionRow: View {
    var title: String
    var isActive: Bool
    var onToggle: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: isActive ? "minus.circle" : "plus.circle")
                    .foregroundColor(isActive ? .red : .black)
            }

            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.leading, 8)

            Spacer()

            Image(systemName: "line.3.horizontal")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(25)
    }
}
