//
//  HeaderView.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/11/25.
//

import SwiftUI

struct HeaderView: View {
    var showBack: Bool = true
    var isLogin: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if showBack {
                    Button(action: {
                        action?()
                    }) {
                        Image("chevronleft")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                } else {
                    //debe aparecer si no esta logeado
                    Button(action: {
                        // Menú lateral o acción
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                    }
                }

                Spacer()

                Image("titulo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)

                Spacer()

                
                if showBack {
                    Button(action: {
                        action?()
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                } else {
                    
                    Button(action: {
                        // Buscar
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            Divider()
                .frame(height: 0.5)
                .background(Color.black)
        }
    }
}
