//
//  RoomsConnect.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift


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
