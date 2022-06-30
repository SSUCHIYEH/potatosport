//
//  AddFriendView.swift
//  potatosport
//
//  Created by 蔡瑀 on 2022/6/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseDatabaseSwift

struct Friend {
    let name:String
    let id:String
    let isOnline:Bool
}

struct beInvitedModel {
    let name:String
    let id:String
}
struct AddFriendView: View {
//    @EnvironmentObject var friendConnectModel:friendCoonectViewModel
    @EnvironmentObject var authViewModel:AppAuthViewModel
    @EnvironmentObject var friendConnectModel:friendCoonectViewModel
    @Binding var showAddFriendView:Bool
    
//  好友列表
    @State var friendsList: [Friend] = []
    
    @State var beInvited : [Friend] = []
    
    @State var queryFriend : [Friend] = []
    
    @State var username = ""
    
    @State var isSearching = false
//  螢幕高度
    let height = UIScreen.main.bounds.height
    
//  控制segmentControl
    @State private var segmentIndex = 0
    
    
//    API:監聽好友列表
    func observeFriend(){
        var ref = Database.database().reference()
        ref.child("users").child(authViewModel.userId).child("friendList").queryOrdered(byChild: "isOnline").observe(.value) { snapshot in
            if(snapshot.exists()){
                for child in snapshot.children.reversed(){
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String:Any]
                    let id = dict["id"] as! String
                    let name = dict["userName"] as! String
                    let isOnline = dict["isOnline"] as! Bool
                    let fr = Friend(name: name, id: id, isOnline: isOnline)
                    self.friendsList.append(fr)
                }
                print(friendsList[0].name)
            }
        }
    }
    
    func searchFriend(queryName:String){
        var ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "userName").queryEqual(toValue: queryName).observeSingleEvent(of: .value) { snapshot in
            if(snapshot.exists()){
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let id = dict["id"] as! String
                    let userName = dict["userName"] as! String
                    print("query",id)
                    let fr = Friend(name: userName, id: id,isOnline: false)
                    self.queryFriend.append(fr)
                }
            }
            self.isSearching = true
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)))
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment:.top){
                ZStack(alignment: .bottom){
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("yellow_300"))
                        .frame(width: 281, height: height - 40)
                }
                VStack{
                    HStack{
                        Spacer()
                        Button(action:{
                            self.showAddFriendView = false
                        },label: {
                            Image("icon_close")
                        })
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                        
                    }
                    HStack{
                        Picker("", selection: $segmentIndex) {
                            Text("邀請遊玩").tag(0)
                            Text("新增好友").tag(1)
                            Text("好友邀請").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 250, height: 30, alignment: .top)
                        Spacer()
                    }.frame(width: 281, height: 20, alignment: .top)
                    ZStack(alignment: .top){
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color("white"))
                            .frame(width: 281, height: height - 120)
                        VStack{
                            switch segmentIndex {
                            case 0:
                                ForEach(0 ..< friendsList.count , id: \.self){ item in
                                    FriendRow(segment:segmentIndex, friend:friendsList[item])
                                }
                            case 1:
                                Spacer()
                                        .frame(height: 10)
                                TextField("名稱",text:$username)
                                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                    .frame(width: 248)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                                    .font(.callout)
                                    .background(Color("gray_200"))
                                    .foregroundColor(Color("dark"))
                                    .onSubmit {
                                        self.friendsList = []
                                        self.searchFriend(queryName: username)
                                        }
                                ForEach(0 ..< queryFriend.count , id: \.self){ item in
                                    FriendRow(segment:segmentIndex, friend:queryFriend[item])
                                }
                                if queryFriend.count == 0 && isSearching {
                                    VStack{
                                        Image("icon_user")
                                        Text("沒有符合的玩家")
                                            .font(.custom("Noto Sans TC Bold", size: 14))
                                    }.padding(.top, 10.0)
                                }
                                
                                
                            case 2:
                                Spacer().frame(height: 10)
                                Text("玩家向您發出的交友邀請都在這裡！")
                                    .font(.custom("Noto Sans TC Bold", size: 14))
                                    .foregroundColor(Color("gray"))
                                ForEach(0 ..< $friendConnectModel.beInvited.count , id: \.self){ item in
                                    FriendRow(segment:segmentIndex, friend:friendConnectModel.beInvited[item])
                                }
                            default:
                                Text("邀請")
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: 281, height: height - 40)
            }.offset(x:0,y:10)
        }
        .padding(.leading, 40.0)
        .frame(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        .onAppear{
            self.observeFriend()
            UISegmentedControl.appearance().selectedSegmentTintColor = .white
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.darkGray], for: .normal)
        }
    }
    
}
struct FriendRow:View{
    @EnvironmentObject var friendConnectModel:friendCoonectViewModel
    @EnvironmentObject var authViewModel:AppAuthViewModel
    @EnvironmentObject var globalSheet:GlobalSheet
    
    let segment:Int
    let friend:Friend
    @State var btnLabel = ""
    func btnAction(){
        switch segment{
        case 0:
            print("邀請遊玩")
            self.friendConnectModel.inviteFriend(frId: friend.id, myId: authViewModel.userId, myName: authViewModel.userName)
            globalSheet.setContent(msg: "已發出邀請")
        case 1:
            print("新增好友")
            self.friendConnectModel.newFriend(myId: authViewModel.userId, myName: authViewModel.userName, newFrId: friend.id)
            globalSheet.setContent(msg: "已發送交友邀請")
        case 2:
            print("好友邀請")
            self.friendConnectModel.acceptFriend(myId: authViewModel.userId, myName: authViewModel.userName, newFrId: friend.id, newFrName: friend.name)
            globalSheet.setContent(msg: "結交新夥伴")
        default:
            print("default")
        }
        globalSheet.visible = true
    }
    
    var body: some View {
        HStack{
            if(friend.isOnline && segment==0){
                Circle()
                    .fill(Color("lightgreen"))
                    .frame(width: 8, height: 8)
            }else if(!friend.isOnline && segment==0){
                Circle()
                    .fill(Color("gray"))
                    .frame(width: 8, height: 8)
            }
            Image("icon_user")
            Text(friend.name).font(.custom("Noto Sans TC Bold", size: 14)).foregroundColor(Color("dark")).tracking(1.8)
            Spacer()
            if(segment == 0 && friend.isOnline) || (segment != 0) {
                Button(action: {
                    self.btnAction()
                }, label: {
                    ZStack{
                        Text(self.btnLabel)
                            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                            .background(Color("red"))
                            .foregroundColor(Color.white)
                            .font(.custom("Noto Sans TC Bold", size: 14))
                            .cornerRadius(5)
                    }
                })
            }
            
        }
        .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
        .onAppear{
            switch segment{
            case 0:
                self.btnLabel = "邀請"
            case 1:
                self.btnLabel = "送出邀請"
            case 2:
                self.btnLabel = "確認"
            default:
                self.btnLabel = "邀請"
            }
        }
    }
}


//struct AddFriendView_Previews: PreviewProvider {
//    static let myEnvObject = AppAuthViewModel()
//    @State static var show = true
//    static var previews: some View {
//        AddFriendView(showAddFriendView: $show).environmentObject(myEnvObject).previewInterfaceOrientation(.landscapeLeft)
//    }
//}
