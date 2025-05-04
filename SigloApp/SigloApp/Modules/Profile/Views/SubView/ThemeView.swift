import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case automatic = "Automático"
    case light = "Modo claro"
    case dark = "Modo oscuro"
}

struct ThemeView: View {
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .automatic

    var body: some View {
        ScrollView {
            HeaderView(
                selectedOption: $selectedOption,
                isMenuOpen: $isMenuOpen,
                isLoggedIn: isLoggedIn
            )
            VStack(alignment: .leading, spacing: 0) {
                Text("APARIENCIA")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.top, 15)
                    .padding(.bottom, 4)

                VStack(spacing: 0) {
                    ForEach(AppearanceMode.allCases.indices, id: \.self) { index in
                        Button(action: {
                            appearanceMode = AppearanceMode.allCases[index]
                        }) {
                            HStack {
                                Text(AppearanceMode.allCases[index].rawValue)
                                    .font(.system(size: 17, weight: .bold))
                                    .foregroundColor(.primary)
                                Spacer()
                                Circle()
                                    .strokeBorder(Color.gray.opacity(0.6), lineWidth: 2)
                                    .background(
                                        Circle()
                                            .fill(appearanceMode == AppearanceMode.allCases[index] ? Color.blue : Color.clear)
                                            .padding(4)
                                    )
                                    .frame(width: 24, height: 24)
                            }
                            .padding(.horizontal)
                            .frame(height: 44)
                        }
                        .background(Color(.systemBackground))
                        if index < AppearanceMode.allCases.count - 1 {
                            Divider()
                                .padding(.leading)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 0)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Configuración") // Usa un título simple aquí
        .toolbar(.hidden, for: .navigationBar)
    }
}
