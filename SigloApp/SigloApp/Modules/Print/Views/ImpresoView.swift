import SwiftUI

struct ImpresoView: View {
    @StateObject var viewModel = PrintViewModel()
    @State private var pushNotificationsEnabled = true
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var isMenuOpen: Bool = false
    @State private var selectedOption: MenuOption? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    HeaderView(
                        selectedOption: $selectedOption,
                        isMenuOpen: $isMenuOpen,
                        isLoggedIn: isLoggedIn
                    )
                    if let selected = selectedOption {
                        NotesView(title: selected.title)
                            .transition(.move(edge: .trailing))
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(TabTypetwo.allCases, id: \.self) { tab in
                                    VStack(spacing: 4) {
                                        Text(tab.rawValue)
                                            .font(.system(size: 14))
                                            .font(.title) // o .title, .headline, .largeTitle, etc.
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .fontWeight(viewModel.selectedTab == tab ? .bold : .regular)
                                            .foregroundColor(viewModel.selectedTab == tab ? .black : .black)
                                            .onTapGesture {
                                                withAnimation {
                                                    viewModel.selectedTab = tab
                                                }
                                            }
                                        
                                        Rectangle()
                                            .fill(viewModel.selectedTab == tab ? Color.red : Color.clear)
                                            .frame(height: 2)
                                    }
                                    .padding(.horizontal, 8)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.white)
                        
                        Divider()
                        
                        PrintCarouselView(viewModel: viewModel)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage).foregroundColor(.red)
                        }
                        
                        ScrollView { }
                        
                        Divider()
                    }
                }
            }
            .onAppear { viewModel.fetchNewspaper() // Se recarga cada vez que se entra a la vista
            }
        }
    }
}
