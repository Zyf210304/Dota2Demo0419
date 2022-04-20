//
//  HeroView.swift
//  Dota2Demo0419
//
//  Created by 张亚飞 on 2022/4/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct HeroView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    let urlHeader = "https://steamcdn-a.akamaihd.net"
    
    @State var isTaped: Int = -1
    
    var body: some View {
        
        ZStack {
            
            Image("jugg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                ScrollViewReader {proxy in
                    
                    VStack(spacing: -60) {
                        
                        ForEach(vm.hero!, id: \.self) { hero in
                            
                            heroCardView(hero)
                                .id(hero.id)
                                .onTapGesture {
                                    
                                    DispatchQueue.main.async {
                                        withAnimation {
                                            self.isTaped = (self.isTaped == hero.id ? -1 : hero.id)
                                            proxy.scrollTo(hero.id, anchor: .center)
                                        }
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

extension HeroView {
    
    func heroCardView(_ hero: Dota2HeroElement) -> some View {
        
        VStack(spacing:0) {
            
            WebImage(url: URL(string: urlHeader + hero.img))
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            if isTaped == hero.id {
//                withAnimation {
                    
                    heroInfoBodyView(data: hero)
//                }
            }
        }
        .frame(width: isTaped == hero.id ? 320 : 240,
               height: isTaped == hero.id ? 500 : 140)
        .background(
            isTaped == hero.id ?
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9960784314, green: 0.8823529412, blue: 0.2509803922, alpha: 1)), Color(#colorLiteral(red: 0.9803921569, green: 0.4392156863, blue: 0.6039215686, alpha: 1))]), startPoint: .bottomTrailing, endPoint: .topLeading)
                : LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3880284131, green: 0.4124510288, blue: 0.437040776, alpha: 0)), Color(#colorLiteral(red: 0.3880284131, green: 0.4124510288, blue: 0.437040776, alpha: 0))]), startPoint: .bottomTrailing, endPoint: .topLeading)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .fixedSize(horizontal: false, vertical: true)
        .scaleEffect(0.9)
        .rotation3DEffect(Angle(degrees:  isTaped == hero.id ? 0 : 40.0),
                          axis: (x: 1.0, y: -1.0, z: 0),
                          anchor: .center,
                          perspective: 1)
        .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)
    }
}

extension HeroView  {
    
    func heroInfoView(data: Dota2HeroElement) -> some View {
        
        VStack {
            
            // heroinfoheaderview
            heroInfoHeaderView(data: data)
            //heroinfobodyview
            heroInfoBodyView(data: data)
        }
    }
    
    func heroInfoHeaderView(data: Dota2HeroElement) -> some View {
        
        VStack(alignment: .center, spacing: 1) {
            
            HStack {
                
                Spacer()
                heroInfoHederElementView(imgName: "Strength_attribute_symbol", content: "\(data.baseStr)" + "+" + "\(data.strGain)")
                Spacer()
                heroInfoHederElementView(imgName: "Agility_attribute_symbol", content: "\(data.baseAgi)" + "+" + "\(data.agiGain)")
                Spacer()
                heroInfoHederElementView(imgName: "Intelligence_attribute_symbol", content: "\(data.baseInt)" + "+" + "\(data.intGain)")
                Spacer()
            }
            padding(5)
            .background {
                
                attributeBackgroundView(type: data.primaryAttr)
            }
            
        }
    }
    
    func heroInfoHederElementView(imgName: String, content: String) -> some View {
        
        VStack(spacing: 1) {
            
            Image(imgName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:40, height:40)
            Text(content)
                .font(.custom("Georgia", size: 14)).bold()
                .foregroundColor(.white)
        }
    }
    
    func heroInfoBodyView(data: Dota2HeroElement) -> some View {
        VStack(alignment: .center, spacing: 1) {
            HStack(alignment: .center) {
                Text(data.localizedName)
                    .font(.title).bold()
                Text(data.attackType.rawValue)
                    .font(.subheadline)
                    .fontWeight(.thin)
                Text("\(data.attackRange)")
                    .font(.subheadline)
                    .fontWeight(.thin)
            }
            .padding(.horizontal, 10)
            HStack {
                ForEach(data.roles.indices) { i in
                    
                    Text(data.roles[i].rawValue)
                        .font(.subheadline)
                        .fontWeight(.thin)
                }
            }
            .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .padding(.horizontal, 10)
            
            Divider().padding(10)
            
            let columns: [GridItem] = [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
            ]
            
            let  dataTitle = ["攻击频率", "弹道速度", "初始HP", "HP成长率", "初始MP", "MP成长率", "基础护甲", "最小攻击间隔", "最大攻击间隔", "移动速度"]
            let  dataContent = [String(format: "%.2f", data.attackRate),
                                "\(data.projectileSpeed)",
                                "\(data.baseHealth)",
                                "\(data.baseMana)",
                                "\(data.baseMana)",
                                String(format: "%.2f", data.baseManaRegen),
                                String(format: "%.2f", data.baseArmor),
                                "\(data.baseAttackMin)",
                                "\(data.baseAttackMax)",
                                "\(data.moveSpeed)"]
 
            LazyVGrid(columns: columns, spacing: 0) {
                
                ForEach(dataTitle.indices, id: \.self) { index in
                    
                    Text(dataTitle[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.3))
                    Text(dataContent[index])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.3))
                }
                
//                Group {
//                    Text("攻击频率")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text(String(format: "%.2f", data.attackRate))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("弹道速度")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text("\(data.projectileSpeed)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//
//                    Text("初始HP")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("\(data.baseHealth)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("HP成长率")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text(String(format: "%.2f", data.baseHealthRegen))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//
//                    Text("初始MP")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("\(data.baseMana)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//
//
//                }
//
//                Group {
//                    Text("MP成长率")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text(String(format: "%.2f", data.baseManaRegen))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text("基础护甲")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text(String(format: "%.2f", data.baseArmor))
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("最小攻击间隔")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text("\(data.baseAttackMin)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text("最大攻击间隔")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("\(data.baseAttackMax)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.clear)
//                    Text("移动速度")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                    Text("\(data.moveSpeed)")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.gray.opacity(0.3))
//                }

            }
            .font(.custom("Georgia", size: 12))
     
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}





struct attributeBackgroundView: View {
    var type: PrimaryAttr
    var body: some View {
        switch type {
        case .str:
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)), Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 0.4861057692))]), startPoint: .top, endPoint: .bottom)
        case .agi:
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.5103846154))]), startPoint: .top, endPoint: .bottom)
        case .int:
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]), startPoint: .top, endPoint: .bottom)
        }
    }
}


struct HeroView_Previews: PreviewProvider {
    static var previews: some View {
        HeroView()
    }
}
