//
//  NavigationRow..swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//

import SwiftUI

struct NavigationRow<Destination: View>: View {
    let title: String
    var trailing: AnyView? = nil
    var destination: Destination?

    init(title: String, trailing: AnyView? = nil, destination: Destination? = nil) {
        self.title = title
        self.trailing = trailing
        self.destination = destination
    }

    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    rowContent
                }
            } else {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
                .font(.body)
            Spacer()
            if let trailing = trailing {
                trailing
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
    }
}
