//
//  SearchLocationView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 2/11/25.
//

import SwiftUI

struct SearchLocationView: View {
    var body: some View {
        VStack{
            HStack(alignment: .top){
                ButtonView(
                    config: ButtonConfig(
                        style: .text,
                        fitContent: true,
                        horizontalPadding: .padding0,
                        verticalPadding: .padding0
                    )
                ) {
                    AppNavigation.pop()
                } content: {
                    HStack {
                        Image(systemName: "arrow.left")
                            .font(.system(size: .iconSize24))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
                .padding(.top, .padding12)
                .padding(.trailing, .padding8)

                VStack{
                    Image(systemName: "record.circle.fill")
                        .font(.system(size: .iconSize20))
                        .foregroundStyle(AppColors.info)
                        .padding(.top, .padding16)
                    Image(systemName: "ellipsis")
                        .font(.system(size: .iconSize20))
                        .foregroundStyle(AppColors.gray300)
                        .rotationEffect(.degrees(90))
                        .padding(.vertical, .padding4)
                    Image("pin")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: .iconSize28, height: .iconSize28)
                        .foregroundStyle(AppColors.error)
                }

                VStack{
                    TextFieldView(
                        placeholder: "Vị trí hiện tại",
                        cornerRadius: .radius12,
                        verticalPadding: .padding10
                    )
                    .padding(.bottom, .padding8)
                    TextFieldView(
                        placeholder: "Điểm bạn muốn đến...",
                        rightIcon:.icon(.system("camera.fill")),
                        iconFont: .subheadline,
                        cornerRadius: .radius12,
                        verticalPadding: .padding10
                    )
                }
                .padding(.trailing, .padding6)

                VStack{
                    Image("vietnam")
                        .resizable()
                        .scaledToFit()
                        .frame(width: .iconSize28, height: .iconSize28)
                        .padding(.top, .padding8)
                        .padding(.bottom, .padding32)

                    Image(systemName: "plus.circle")
                        .font(.system(size: .iconSize20))
                        .foregroundStyle(AppColors.textPrimary)
                }
            }
            .padding(.top, .padding20)
            .padding(.horizontal, .padding20)
            .padding(.bottom, .padding8)
            .shadow(color: AppColors.shadowXS, radius: .radius8, x: 0, y: 12)

            ScrollView{
                VStack {
                    ForEach(0..<20){ _ in
                        HStack {
                            HStack (spacing: .spacing12){
                                Image(systemName: "clock.fill")
                                    .font(.system(size: .iconSize20))
                                    .foregroundStyle(AppColors.textPrimary)
                                    .padding(.horizontal, .padding12)

                                Text("01 Phạm Hùng, Q.Nam Từ Liêm, TP.Hà Nội")
                                
                                ButtonView(
                                    config: ButtonConfig(
                                        style: .text,
                                        fitContent: true,
                                        horizontalPadding: .padding12,
                                        verticalPadding: .padding8
                                    )
                                ) {
                                    // Handle payment method selection
                                } content: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: .iconSize16))
                                        .foregroundStyle(AppColors.textPrimary)
                                        .rotationEffect(.degrees(90))
                                }
                            }
                        }
                        Divider()
                    }
                    .padding(.horizontal, .padding24)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchLocationView()
}
