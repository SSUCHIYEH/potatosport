import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift


class gameConnectViewModel: ObservableObject{
    @Published var point = 0
    @Published var users = [String: UserPlayer]()
    @Published var roomId = ""
    @Published var myId = ""
    @Published var time = 0
    @Published var reward = [String: Any]()
    //監聽分數的更新
    func observeGamePoint(){
        var ref = Database.database().reference()
        ref.child("rooms").child(self.roomId).observe(.value) { snapshot in
            if(snapshot.exists()){
                for child in snapshot.children{
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    self.users = dict["users"] as! [String: UserPlayer]
                }
            }
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
            self.time += 1
            if(self.time == 60){
                print("結算遊戲")
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
    
}
