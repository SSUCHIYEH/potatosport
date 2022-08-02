//
//  friendConnect.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift


class friendCoonectViewModel: ObservableObject {
    @Published var firendList = [UserInfo]()
    @Published var selfPlyaers = [String: UserPlayer]()
    @Published var isLeader = true
    @Published var friendRoomId = ""
    @Published var leaderId = ""
    @Published var myId = ""
    @Published var beInvited : [Friend] = []
    //--initSet-----
    func initSetFriend(myId:String,myName:String){
        let docs = UserPlayer(id: myId, userName: myName, point: 0, time: 0, ready: false)
        self.selfPlyaers[myId] = docs
    }
    
    
    
    //------ 薪增好友 ---------
    func newFriend(myId:String,myName:String,newFrId:String){
        var ref = Database.database().reference()
        let inviteInfo = [
            "laucherName":myName,
            "laucherId":myId,
            "inviteId":newFrId
        ] as [String : Any]
        ref.child("newFriend").child(newFrId).setValue(inviteInfo)
    }
    
    // ----- 接受交友邀請 ---------
    func acceptFriend(myId:String,myName:String,newFrId:String,newFrName:String){
        var ref = Database.database().reference()
        // 在自己加入好友
        let fr = [
            "id":newFrId,
            "userName":newFrName,
            "isOnline":true
        ] as [String : Any]
        ref.child("users").child(myId).child("friendList").child(newFrId).setValue(fr)
        // 在對方加入自己
        let me = [
            "id":myId,
            "userName":myName,
            "isOnline":true
        ] as [String : Any]
        ref.child("users").child(newFrId).child("friendList").child(myId).setValue(me)
        // 移除邀請資料
        ref.child("newFriend").child(myId).removeValue()
        beInvited = []
        
    }
    
    // ------搜尋玩家----------
//    func searchFriend(queryName:String){
//        var ref = Database.database().reference()
//        ref.child("users").queryOrdered(byChild: "userName").queryEqual(toValue: queryName).observeSingleEvent(of: .value) { snapshot in
//            if(snapshot.exists()){
//                for child in snapshot.children{
//                    let snap = child as! DataSnapshot
//                    let dict = snap.value as! [String: Any]
//                    let id = dict["id"] as! String
//                    let userName = dict["userName"] as! String
//                    self.queryFriend.append(beInvitedModel(name: userName, id: id))
//                }
//            }
//        }
//    }
    
    // ------邀請好友進房間 ---------
    func inviteFriend(frId:String,myId:String,myName:String){
        var ref = Database.database().reference()
        
        guard let inviteRoomId = ref.child("friendRooms").childByAutoId().key else { return }
        if friendRoomId == "" {
            friendRoomId = inviteRoomId
        }
        let docs = [
            "leaderId":myId,
            "leaderName":myName,
            "inviteId":frId,
            "inviteRoomId":friendRoomId
        ]
        ref.child("inviteRoom").child(frId).setValue(docs)
        self.leaderId = myId
        self.observeFriendRoom()
        
    }
    
    
    // ------接受邀請進房間---------
    func acceptInviteGame(inviteRoomId:String,myId:String,myName:String,leaderId:String,leaderName:String){
        var ref = Database.database().reference()
        
        ref.child("friendRooms").child(inviteRoomId).observeSingleEvent(of: .value){ snapshot in
            var users = [String: Any]()
            
            if(snapshot.exists()){
                // 加入現有的好友房間
                let docs = [
                    "id":myId,
                    "userName":myName,
                ]
                //加入已存在的好友房
                ref.child("friendRooms").child(inviteRoomId).child("users").updateChildValues([
                    "/\(myId)":docs,
                ])
            }else{
//                創建好友房間
                users[myId] = [
                    "id":myId,
                    "userName":myName,
                ]
                users[leaderId] = [
                    "id":leaderId,
                    "userName":leaderName,
                ]
                let me = UserPlayer(id: myId, userName: myName, point: 0, time: 0, ready: false)
                let leader = UserPlayer(id: leaderId, userName: leaderName, point: 0, time: 0, ready: false)
                self.selfPlyaers[myId] = me
                self.selfPlyaers[leaderId] = leader
                let dict = [
                    "users":users,
                    "leaderId":leaderId,
                    "hasRoom":false,
                    "roomId":""
                ] as [String : Any]
                
                //第一個被邀請的人建立好友房
                ref.child("friendRooms").child(inviteRoomId).setValue(dict)
            }
        }
        self.isLeader = false
        self.friendRoomId = inviteRoomId
        self.observeFriendRoom()
        // 移除邀請進房資料
        ref.child("inviteRoom").child(myId).removeValue()
        
    }
    
    // 監聽好友房間 (有無配對)
    func observeFriendRoom(){
        var ref = Database.database().reference()
        ref.child("friendRooms").child(self.friendRoomId).observe(.value) { snapshot in
            self.selfPlyaers = [String: UserPlayer]()
            if snapshot.exists(){
                let snap = snapshot as! DataSnapshot
                let dict = snap.value as! [String:Any]
                if dict["leaderId"] == nil {
                    // 房主離開房間消失
                    self.exitFriendRoom(getOut:true)
                }else {
//                    let users = dict["users"] as! [String:Any]
                    if dict["users"] != nil {
                        let users = dict["users"] as! [String:Any]
                        for u in users {
                            let info = u.value as! [String:Any]
                            let id = info["id"] as! String
                            let name = info["userName"] as! String
                            let docs = UserPlayer(id: id, userName: name, point: 0, time: 0, ready: false)
                            self.selfPlyaers[id] = docs
                        }
                    }
                    let hasRoom = dict["hasRoom"] as! Bool
                }
            }
        }
    }
    
    // 離開好友房間
    func exitFriendRoom(getOut:Bool){
        var ref = Database.database().reference()
        ref.child("friendRooms").child(friendRoomId).child("users").child(myId).removeValue()
        ref.child("friendRooms").removeAllObservers()
        if isLeader {
            ref.child("friendRooms").child(friendRoomId).child("leaderId").removeValue()
            if(selfPlyaers.count == 1){
                ref.child("friendRooms").child(friendRoomId).removeValue()
            }
            
        }
        else if isLeader != true {
            self.isLeader = true
            if getOut { // 被趕出來房間
                ref.child("friendRooms").child(friendRoomId).removeValue()
            }
        }
        self.selfPlyaers = [String: UserPlayer]()
        self.friendRoomId = ""
        
    }
}
