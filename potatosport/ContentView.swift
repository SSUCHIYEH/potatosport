//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift

struct UserInfo: Identifiable {
    var id:String
    var userName:String
    var isOnline:Bool
}

struct UserPlayer: Identifiable {
    var id:String
    var userName:String
    var point:Int
}

struct GameRoomType : Identifiable{
    var id:String
    var mode:String
    var fill:Bool
    var players:Int
    var users:[UserPlayer]
}

class roomsConnetModel: ObservableObject{
    var ref = Database.database().reference()
    var db = Firestore.firestore()
    func connecting(mode:String, players:Int, completion: @escaping (_ HasRoom:Bool,_ RoomId:String,_ Players:Int) -> Void){
        //判斷mode player
        var _hasRoom : [Bool] = []
        var _roomId : [String] = []
        var _players : [Int] = []
        db.collection("gameRooms").whereField("mode", isEqualTo: mode)
            .addSnapshotListener { querySnapshot, error in
                guard (querySnapshot?.documents) != nil else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                querySnapshot?.documents.map{ (item) in
                    let total = item["players"] as! Int + players
                    if total <= 8 {
                        _roomId.append(item["roomId"]as! String)
                        _players.append(item["players"]as! Int)
                        print(_roomId,_players,_hasRoom)
                    }
                }
                completion(true,"IVTHo2HjFyd5jiOFccFT",0)
            }
    }
    func createGameRoom(){
        
    }
    func joinGameRoom(users:Array<Any>,roomId:String,players:Int){
        let newPlayers = players + users.count
        let allUsers:[String:Any] = [
            "users":users,
            "players":newPlayers,
        ]
        print("房間Id",roomId)
        db.collection("gameRooms").document(roomId).updateData(allUsers) {err in
            if let err = err {
                print("加入房間錯誤")
            } else{
                print("加入房間成功")
            }
        }
    }
}


class AppAuthViewModel: ObservableObject{
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignIn:Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email:String,password:String){
        auth.signIn(withEmail: email, password: password) { [weak self]result, error in
            guard result != nil,error == nil else{ return }
            
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
          }
    }
    func signOut(){
        do {
            self.signedIn.toggle()
            try auth.signOut()
        } catch let error as NSError {
          print("Error signing out: %@", error)
        }
    }
}


struct ContentView: View {
    @State var email = ""
    @State var password = ""
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @EnvironmentObject var viewModel:AppAuthViewModel
    
    var body: some View {
        NavigationView{
            if viewModel.signedIn {
                IndexView()
            } else {
                SignInView()
            }
        }.onAppear{
            viewModel.signedIn = viewModel.isSignIn
        }
    }
}

class RoomInfo: ObservableObject {
    @Published var fill = false
    @Published var hasRoom = false
    @Published var roomId = ""
    @Published var players = 0
    @Published var users = [String:Any]()
    @Published var selfPlyaers = [UserPlayer]()
    init(){
        //API: 呼叫個人資料
        self.selfPlyaers.append(UserPlayer(
            id:"user_1",userName:"Ruby3",point:0
        ))
        self.hasRoom = false
    }
}

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

// 登入
struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @State private var orientation = UIDeviceOrientation.unknown
    
    @EnvironmentObject var viewModel:AppAuthViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("帳號",text:$email).padding().border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                SecureField("密碼",text:$password).padding().border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                Button(action: {
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                    
                },label:{
                    Text("登入")
                        .foregroundColor(Color.white)
                        .frame(width:200, height:50)
                        .background(Color.blue).cornerRadius(8)
                })
            }.padding()
        }
        .padding(.horizontal, 20.0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

