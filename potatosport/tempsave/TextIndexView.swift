//
//  TextIndexView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/21.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift
import Foundation

// 主畫面
struct IndexView: View {
//  好友列表
    @State private var frienddata = [UserInfo]()
//  遊戲模式
    @State private var mode:String = "mode2"
//  是房長嗎
    @State private var isLeader:Bool = true

    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @EnvironmentObject var viewModel:AppAuthViewModel
    
//  配對房間資訊
    @ObservedObject var roomInfo = RoomInfo()
    
    private var firebaseObject = roomsConnetModel()
    
    func searchRoom(){
        print("重複searchRoom")
        let players = self.roomInfo.selfPlyaers.count
        var ref = Database.database().reference()
        ref.child("rooms").queryOrdered(byChild: "mode").queryEqual(toValue: self.mode).observeSingleEvent(of: .value) { snapshot in
            if(snapshot.exists()){
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let id = dict["roomId"] as! String
                    let roomPlayers = dict["players"] as! Int
                    let totalP = players + roomPlayers
                    let users = dict["users"] as! [String:Any]
                    if totalP <= 8 {
                        self.roomInfo.hasRoom = true
                        self.roomInfo.roomId = id
                        self.roomInfo.players = totalP
                        self.roomInfo.users = users
                    }
                }
                print("有沒有房間",self.roomInfo.hasRoom)
                if(self.roomInfo.hasRoom){
                    self.joinRoom()
                }
            }
        }
        if(self.roomInfo.hasRoom == false){
            self.creatRoom()
        }
    }
    func creatRoom(){
        print("創建房間")
        var ref = Database.database().reference()
        var users = [String:Any]()
        guard let roomId = ref.child("posts").childByAutoId().key else { return }
        for u in self.roomInfo.selfPlyaers{
            users[u.id] = [
                "id":u.id,
                "userName":u.userName,
                "point":0,
            ]
        }
        print(roomId)
        let cRoom = [
            "players":self.roomInfo.selfPlyaers.count,
            "fill":false,
            "mode":self.mode,
            "roomId":roomId,
            "users":users,
        ] as [String : Any]
        ref.child("rooms").child(roomId).setValue(cRoom)
    }
    
    func joinRoom(){
        var ref = Database.database().reference()
        let jRoom = [
            "players":self.roomInfo.players,
            "fill":self.roomInfo.fill,
            "mode":self.mode,
            "roomId":self.roomInfo.roomId,
            "users":self.roomInfo.users,
        ] as [String : Any]
        ref.child("rooms").updateChildValues([
            "/\(self.roomInfo.roomId)":jRoom,
        ])
        
        for u in self.roomInfo.selfPlyaers{
            let postUser = [
                "id":u.id,
                "userName":u.userName,
                "point":0
            ] as [String : Any]
            
            ref.child("rooms").updateChildValues([
                "/\(self.roomInfo.roomId)/users/\(u.id)":postUser
            ])

        }
    }
    
    
    
    func outRoom(){
        print("退出房間")
        self.roomInfo.hasRoom = false
    }
    
    var body: some View {
        VStack {
            Text("遊戲大廳")
            Button(action: {
                self.searchRoom()
            },label:{
                Text("開始配對")
                    .foregroundColor(Color.white)
                    .frame(width:200, height:50)
                    .background(Color.blue).cornerRadius(8)
            })
            Button(action: {
                viewModel.signOut()
            },label:{
                Text("登出")
                    .foregroundColor(Color.white)
                    .frame(width:200, height:50)
                    .background(Color.blue).cornerRadius(8)
            })
        }.padding()
    }
}
