import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift


class gameConnectViewModel: ObservableObject{
    @Published var point = 0
    @Published var players = 0
    @Published var users = [String: UserPlayer]()
    @Published var roomId = ""
    @Published var myId = ""
    @Published var time = 30
    @Published var reward = [String: Any]()
    @Published var gameState = 0
    @Published var allReady = false
    @Published var frUserPos:Float = 0
    @Published var readyP = 0
    @Published var single = false
    //監聽分數的更新
    func observeGamePoint(){
        var ref = Database.database().reference()
        ref.child("rooms").child(self.roomId).observe(.value) { snapshot in
            if(snapshot.exists()){
                let snap = snapshot as! DataSnapshot
                let dict = snap.value as! [String:Any]
                let remoteUser = dict["users"] as! [String: Any]
                for u in remoteUser{
                    let value = u.value as! [String:Any]
                    let id = value["id"] as! String
                    let name = value["userName"] as! String
                    let time = value["time"] as! Int
                    let point = value["point"] as! Float
                    let ready = value["ready"] as! Bool
                    if id != self.myId {
                        self.frUserPos = point
                    }
                    self.users[u.key] = UserPlayer(id: id, userName: name, point: point, time: time, ready: ready)
                }
                self.players = dict["players"] as! Int
                self.readyP = dict["allReady"] as! Int
                if !self.allReady && self.players == self.readyP {
                    self.allReady = true
                    self.gameState = 4
                }
            }
        }
    }
    
    func setReady(){
        var ref = Database.database().reference()
        ref.child("rooms").child(self.roomId).updateChildValues([
            "users/\(self.myId)/ready":true,
            "allReady" : self.readyP + 1
        ])
        if single{
            print("single")
            self.setFakerReady()
        }
    }
    
    // 增加分數
    func addPoint(){
        var ref = Database.database().reference()
        self.point = self.point + 10
        
//      if(point > 終點){
//            "time":self.timer
//    }
        ref.child("rooms").child(self.roomId).child("users").child(self.myId).updateChildValues([
            "point":self.point,
        ])
    }
    
    func gameClock(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            // Your function here
            self.time -= 1
            if self.single {
                if(self.time % 4 == 0){
                    self.setFakerPos()
                }
            }
            if(self.time == 0){
                self.gameState = 5
                print("時間到",self.gameState)
                timer.invalidate()
            }
        })
    }
    
//   結算分數
    func calPoint(){
        var ref = Database.database().reference()
        ref.child("rooms").child(self.roomId).removeAllObservers()
        self.users.sorted(by:{
            $0.value.point > $1.value.point
        })
        self.users.sorted(by:{
            $0.value.time < $1.value.time
        })
        var noIndex = 0
        var noFinish = false
        for(index,u) in self.users{
            if(u.time != 0) {
                noIndex += 1
                self.reward["\(noIndex)"] = u
            }else{
                if(noFinish != true){
                    noIndex += 1
                    noFinish = true
                }
                self.reward["\(noIndex)"] = u
            }
        }
    }
    
    func reserGameInfo(){
        self.point = 0
        self.users = [String: UserPlayer]()
        self.roomId = ""
        self.time = 0
        self.reward = [String: Any]()
    }
    
    func setFakerReady() {
        var ref = Database.database().reference()
        ref.child("rooms").child(self.roomId).updateChildValues([
            "users/fakePlayer/ready": false,
            "allReady":2
        ])
    }
    
    func setFakerPos() {
        var ref = Database.database().reference()
        if self.frUserPos > -2{
            ref.child("rooms").child(self.roomId).child("users").child("fakePlayer").updateChildValues([
                "point": self.frUserPos - 0.2
            ])
        }
    }
    
}
