//
//  TabBarView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, .padding16)
        .padding(.vertical, .padding12)
        .padding(.bottom, .padding8)
        .background(
            RoundedRectangle(cornerRadius: .radius0)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: -2
                )
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: .spacing4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 24, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryGreenLight : AppColors.textSecondary)
                    .frame(height: 28)

                Text(tab.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryGreenLight : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, .padding8)
//            .background(
//                RoundedRectangle(cornerRadius: .radius16)
//                    .fill(isSelected ? AppColors.primaryGreenLight.opacity(0.1) : Color.clear)
//            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        TabBarView(selectedTab: .constant(.home))
    }
    .background(Color.gray.opacity(0.1))
    .edgesIgnoringSafeArea(.bottom)
}
