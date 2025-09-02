import Foundation
import SwiftUI

struct TabsHeaderView: View {
    let tabs = ["NOTICIAS", "VIDEOS", "ANUNCIOS", "FOTOS"]
    @State private var selectedTab = "NOTICIAS"
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(tabs, id: \.self) { tab in
                VStack {
                    Text(tab)
                        .font(.system(size: 13)) 
                        .fontWeight(selectedTab == tab ? .bold : .regular)
                        .foregroundColor(.black)
                    
                    // Línea inferior activa
                    Rectangle()
                        .fill(selectedTab == tab ? Color.red : Color.clear)
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
                .onTapGesture {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal)
    }
}

