//
//  HistoryLocation.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 25/10/25.
//

import SwiftUI

struct HistoryLocation: View {
    var body: some View {
        VStack (alignment: .leading){
            ForEach(0..<3) { _ in
                HStack {
                    Circle()
                        .foregroundStyle(AppColors.grabCarBg)
                        .frame(width: .spacing52, height: .spacing52)
                        .overlay(
                            Image("pin")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .spacing24, height: .spacing24)
                                .padding(.spacing4)
                        )
                        .padding(.horizontal, .padding10)
                    VStack(alignment: .leading){
                        Text("01 Phạm Hùng")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textPrimary)

                        Text("01 Phạm Hùng, Q.Nam Từ Liêm, TP.Hà Nội")
                            .font(.subheadline)
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(.vertical, .padding6)
            }
        }
    }
}

#Preview {
    HistoryLocation()
}
