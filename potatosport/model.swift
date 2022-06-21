
import Foundation


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
