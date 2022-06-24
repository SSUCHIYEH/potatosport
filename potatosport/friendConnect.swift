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
    @Published var selfPlyaers = [String: Any]()
    @Published var isLeader = true
    @Published var friendRoomId = ""
    @Published var leaderId = ""
    @Published var myId = ""
    
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
        ref.child("inviteRoom").child(myId).removeValue()
        
    }
    
    // ------邀請好友進房間 ---------
    func inviteFriend(frId:String,myId:String,myName:String){
        var ref = Database.database().reference()
        guard let inviteRoomId = ref.child("inviteRoom").childByAutoId().key else { return }
        let docs = [
            "leaderId":myId,
            "leaderName":myName,
            "inviteId":frId,
            "inviteRoomId":inviteRoomId
        ]
        ref.child("inviteRoom").child(inviteRoomId).setValue(docs)
        self.leaderId = myId
        
        
    }
    
    
    // ------接受邀請進房間---------
    func acceptInviteGame(inviteRoomId:String,myId:String,myName:String,leaderId:String,leaderName:String){
        var ref = Database.database().reference()
        
        ref.child("friendRooms").queryOrdered(byChild: "leaderId").queryEqual(toValue: leaderId).getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            var users = [String: Any]()
            
            if(snapshot!.exists()){
                // 加入現有的好友房間
                for child in snapshot!.children{
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    users = dict["users"] as! [String: Any]
                }
                users[myId] = [
                    "id":myId,
                    "userName":myName,
                ]
                let docs = [
                    "users":users
                ]
                
                //加入已存在的好友房
                ref.child("friendRooms").updateChildValues([
                    "/\(leaderId)":docs,
                ])
            }else{
//                創間好友房間
                users[myId] = [
                    "id":myId,
                    "userName":myName,
                ]
                users[leaderId] = [
                    "id":leaderId,
                    "userName":leaderName,
                ]
                var dict = [String:Any]()
                dict = [
                    "users":users,
                    "leaderId":leaderId,
                    "players":2
                ]
                //第一個被邀請的人建立好友房
                ref.child("friendRooms").child(leaderId).setValue(dict)
            }
        })
        
        // 移除邀請進房資料
        ref.child("inviteRoom").child(inviteRoomId).removeValue()
    }
                                                                                                         
}
