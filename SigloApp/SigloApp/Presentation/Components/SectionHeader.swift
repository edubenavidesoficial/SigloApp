//
//  SectionHeader.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//
import SwiftUI

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
