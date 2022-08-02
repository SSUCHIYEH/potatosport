//
//  PersonalView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/7/3.
//

import Foundation
import SwiftUI


struct PersonalView:View{
//    @Binding var showBackBtn:Bool
    
    var body: some View{
//        HStack(alignment: .top, spacing: 3089) {
//            ZStack {
//                RoundedRectangle(cornerRadius: 5)
//                .fill(Color(red: 0.31, green: 0.26, blue: 0.39))
//                .offset(x: -18.08, y: -11.71)
//                .frame(width: 53.17, height: 50.42)
//
//                Rectangle()
//                .fill(Color(red: 0.50, green: 0.23, blue: 0.27, opacity: 0.50))
//                .frame(width: 34, height: 35)
//                .padding(10)
//                .offset(x: -19.92, y: -16.95)
//                .frame(width: 53.17, height: 49.11)
//                .background(Color(red: 1, green: 0.94, blue: 0.40))
//                .cornerRadius(5)
//                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 4))
//            }
//            .frame(width: 55, height: 55)
//
//            ZStack {
//                Text("運動紀錄與分析")
//                .fontWeight(.medium)
//                .font(.callout)
//                .tracking(1.60)
//                .lineSpacing(23.04)
//                .padding(.horizontal, 14)
//                .padding(.top, 10)
//                .padding(.bottom, 13)
//                .offset(x: 98, y: -175.50)
//                .frame(width: 165)
//                .background(Color(red: 1, green: 0.80, blue: 0.16))
//                .cornerRadius(5)
//
//                HStack(spacing: 11) {
//                        Text("阿毛")
//                        .fontWeight(.medium)
//                        .font(.title3)
//                        .tracking(2)
//                        .lineSpacing(28.80)
//
//                        Rectangle()
//                        .fill(Color(red: 0.50, green: 0.23, blue: 0.27, opacity: 0.50))
//                        .frame(width: 20, height: 20)
//                }
//                .padding(.horizontal, 14)
//                .padding(.top, 10)
//                .padding(.bottom, 23)
//                .offset(x: -421, y: -176.50)
//                .frame(height: 52)
//                .background(Color(red: 1, green: 0.80, blue: 0.16))
//                .cornerRadius(5)
//            }
//            .frame(width: 655, height: 357)
//        }
//        .padding(.leading, 19)
//        .padding(.top, 14)
//        .frame(width: 896, height: 414)
//        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.75, green: 0.90, blue: 0.66), Color(red: 0.91, green: 1, blue: 0.86)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        
        
        
        ZStack{
            Image("personal_bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Image("personal_content")
                .resizable()
                .frame(width: 550, height: 320)
            ZStack(alignment: .top) {
                VStack{
                    HStack{
                        HStack{
                            Text("阿毛")
                            .foregroundColor(Color.white)
                            .fontWeight(.medium)
                            .font(.title3)
                            .tracking(2)
                            .lineSpacing(28.80)

                            Image(systemName: "pencil")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20, weight: .black))
                            
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .padding(.bottom, 15)
                        .frame(height: 52)
                        .background(Color(red: 1, green: 0.80, blue: 0.16))
                        .cornerRadius(5)
                        Spacer()
                        Text("運動紀錄與分析")
                        .foregroundColor(Color.white)
                        .fontWeight(.medium)
                        .font(.callout)
                        .lineSpacing(23.04)
                        .padding(.horizontal, 14)
                        .padding(.top, 10)
                        .padding(.bottom, 13)
                        .frame(width: 165)
                        .background(Color(red: 1, green: 0.80, blue: 0.16))
                        .cornerRadius(5)
                    }.padding(EdgeInsets(top: 0, leading: 88, bottom: 0, trailing: 88))
                    Spacer()
                }.padding(.top,20)
                VStack{
                    HStack{
                        VStack{
                            Text("各部位表現")
                            RadarChartView(
                                width: 240,
                                MainColor: Color.init(white: 0.8),
                                SubtleColor: Color.init(white: 0.6),
                                quantity_incrementalDividers: 10,
                                dimensions: dimensions,
                                data: data
                            )
                        }
                        Spacer()
                        VStack{
                            Text("本週運動量")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    Spacer()
                }
                .padding(.top,60)
                .padding(.horizontal,88)
                
            }
            VStack{
                HStack(alignment:.top){
                    Button(action: {
    //                    self.showBackBtn = false
                    }, label: {
                        Image("back_btn")
                            .resizable()
                            .frame(width: 55, height: 55)
                    })
                    Spacer()
                }
                Spacer()
            }.padding(EdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 0))

        }
    }
}



struct PersonalView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            PersonalView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

let dimensions = [
    Ray(maxVal: 100, rayCase: .Base),
    Ray(maxVal: 100, rayCase: .Content),
    Ray(maxVal: 100, rayCase: .SpeedWeb),
    Ray(maxVal: 100, rayCase: .SpeedMobile),
    Ray(maxVal: 100, rayCase: .Social)
]

let data = [
    DataPoint(base: 58.9, content: 20.3, speedweb: 91, speedmobile: 56.01, social: 55.6, color: .blue),
]


enum RayCase:String, CaseIterable {
    case Base = "Base"
    case Content = "Content"
    case SpeedWeb = "SpeedWeb"
    case SpeedMobile = "SpeedMobile"
    case Social = "Social"
}

struct DataPoint:Identifiable {
    var id = UUID()
    var entrys:[RayEntry]
    var color:Color
    
    init(base:Double, content:Double, speedweb:Double, speedmobile:Double, social:Double, color:Color){
        self.entrys = [
            RayEntry(rayCase: .Base, value: base),
            RayEntry(rayCase: .Content, value: content),
            RayEntry(rayCase: .SpeedWeb, value: speedweb),
            RayEntry(rayCase: .SpeedMobile, value: speedmobile),
            RayEntry(rayCase: .Social, value: social)
        ]
        self.color = color
    }
}

struct Ray:Identifiable {
    var id = UUID()
    var name:String
    var maxVal:Double
    var rayCase:RayCase
    init(maxVal:Double, rayCase:RayCase) {
        self.rayCase = rayCase
        self.name = rayCase.rawValue
        self.maxVal = maxVal
        
    }
}

struct RayEntry{
    var rayCase:RayCase
    var value:Double
}

func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
}

func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
}

func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
    return 360 * (CGFloat((numerator))/CGFloat(denominator))
    
}

struct RadarChartView: View {
    
    var MainColor:Color
    var SubtleColor:Color
    var center:CGPoint
    var labelWidth:CGFloat = 70
    var width:CGFloat
    var quantity_incrementalDividers:Int
    var dimensions:[Ray]
    var data:[DataPoint]
    
    init(width: CGFloat, MainColor:Color, SubtleColor:Color, quantity_incrementalDividers:Int, dimensions:[Ray], data:[DataPoint]) {
        self.width = width
        self.center = CGPoint(x: width/2, y: width/2)
        self.MainColor = MainColor
        self.SubtleColor = SubtleColor
        self.quantity_incrementalDividers = quantity_incrementalDividers
        self.dimensions = dimensions
        self.data = data
    }
    
    @State var showLabels = false
    
    var body: some View {
        
        ZStack{
            //Main Spokes
            Path { path in
                
                
                for i in 0..<self.dimensions.count {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            //Labels
            ForEach(0..<self.dimensions.count){i in
                
                Text(self.dimensions[i].rayCase.rawValue)
                    
                    .font(.system(size: 10))
                    .foregroundColor(self.SubtleColor)
                    .frame(width:self.labelWidth, height:10)
                    .rotationEffect(.degrees(
                        (degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) > 90 && degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) < 270) ? 180 : 0
                        ))
                    
                    
                    .background(Color.clear)
                    .offset(x: (self.width - (50))/2)
                    .rotationEffect(.radians(
                        Double(radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    )))
            }
            //Outer Border
            Path { path in
                
                for i in 0..<self.dimensions.count + 1 {
                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                    
                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
                    if i == 0 {
                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
                    } else {
                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
                    }
                    
                    
                }
                
            }
            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            //Incremental Dividers
            ForEach(0..<self.quantity_incrementalDividers){j in
                Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(j + 1)/CGFloat(self.quantity_incrementalDividers + 1))
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (50 + self.labelWidth)))
                        print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                .stroke(self.SubtleColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
                
                
            }
            
            //Data Polygons
            ForEach(0..<self.data.count){j -> AnyView in
                //Create the path
                let path = Path { path in
                    
                    
                    for i in 0..<self.dimensions.count + 1 {
                        let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
                        let maxVal = thisDimension.maxVal
                        let dataPointVal:Double = {
                            
                            for DataPointRay in self.data[j].entrys {
                                if thisDimension.rayCase == DataPointRay.rayCase {
                                    return DataPointRay.value
                                }
                            }
                            return 0
                        }()
                        let angle = radAngle_fromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
                        
                        
                        let x = size * cos(angle)
                        let y = size * sin(angle)
                        print(size)
                        print((self.width - (50 + self.labelWidth)))
                        print("\(x) -- \(y)")
                        if i == 0 {
                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        } else {
                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
                        }
                        
                    }
                    
                }
                //Stroke and Fill
                return AnyView(
                    ZStack{
                        path
                            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                        path
                            .foregroundColor(self.data[j].color).opacity(0.2)
                    }
                )
                
                
            }
            
        }.frame(width:width, height:width)
    }
}



//
//struct RadarChartGrid: Shape {
//  let categories: Int
//  let divisions: Int
//
//  func path(in rect: CGRect) -> Path {
//    let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
//    let stride = radius / CGFloat(divisions)
//    var path = Path()
//
//    for category in 1 ... categories {
//      path.move(to: CGPoint(x: rect.midX, y: rect.midY))
//      path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius,
//                               y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * radius))
//    }
//
//    for step in 1 ... divisions {
//      let rad = CGFloat(step) * stride
//      path.move(to: CGPoint(x: rect.midX + cos(-.pi / 2) * rad,
//                            y: rect.midY + sin(-.pi / 2) * rad))
//
//      for category in 1 ... categories {
//        path.addLine(to: CGPoint(x: rect.midX + cos(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad,
//                                 y: rect.midY + sin(CGFloat(category) * 2 * .pi / CGFloat(categories) - .pi / 2) * rad))
//      }
//    }
//
//    return path
//  }
//}
//
//struct RadarChartPath: Shape {
//  let data: [Double]
//
//  func path(in rect: CGRect) -> Path {
//    guard
//      3 <= data.count,
//      let minimum = data.min(),
//      0 <= minimum,
//      let maximum = data.max()
//    else { return Path() }
//
//    let radius = min(rect.maxX - rect.midX, rect.maxY - rect.midY)
//    var path = Path()
//
//    for (index, entry) in data.enumerated() {
//      switch index {
//        case 0:
//          path.move(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
//                                y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
//
//        default:
//          path.addLine(to: CGPoint(x: rect.midX + CGFloat(entry / maximum) * cos(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius,
//                                   y: rect.midY + CGFloat(entry / maximum) * sin(CGFloat(index) * 2 * .pi / CGFloat(data.count) - .pi / 2) * radius))
//      }
//    }
//    path.closeSubpath()
//    return path
//  }
//}
//
//struct RadarChart: View {
//  var data: [Double]
//  let gridColor: Color
//  let dataColor: Color
//
//  init(data: [Double], gridColor: Color = .gray, dataColor: Color = .blue) {
//    self.data = data
//    self.gridColor = gridColor
//    self.dataColor = dataColor
//  }
//
//  var body: some View {
//    ZStack {
//      RadarChartGrid(categories: data.count, divisions: 10)
//        .stroke(gridColor, lineWidth: 0.5)
//
//      RadarChartPath(data: data)
//        .fill(dataColor.opacity(0.3))
//
//      RadarChartPath(data: data)
//        .stroke(dataColor, lineWidth: 2.0)
//    }
//  }
//}
