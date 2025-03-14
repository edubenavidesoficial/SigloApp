//
//  ToggleRow.swift
//  SigloApp
//
//  Created by Macbook Pro 17 i5R on 3/14/25.
//
import SwiftUI

struct ToggleRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading) {
                    Text(title)
                        .fontWeight(.medium)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .padding(.vertical, 10)
    }
}
