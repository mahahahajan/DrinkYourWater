//
//  MySettings.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 1/25/22.
//
import Foundation

//let testTime = 15.0;
//let minute = 60.0;
//let hour = minute * 60;

struct Preferences{
    static var reminderTime: TimeInterval {
        get{
            let currTime = UserDefaults.standard.double(forKey: "reminderTime")
            if currTime > 0 {
                return currTime
            }
            #if DEBUG
                print("debug")
                return 15
            #else
                return 60 * 60 * 2
            #endif
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reminderTime")
        }
    }
    static var resetTime: String {
        get{
            let currResetTime = UserDefaults.standard.string(forKey: "resetTime")
            if (currResetTime != nil) {
                print("had reset time ")
                return currResetTime!
            } else {
                //currResetTime == nil
                return "19:19"
            }
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "resetTime")
        }
    }
    static var notifTypeNum: Int {
        get{
            let currNotifType = UserDefaults.standard.integer(forKey: "notifType")
            if(currNotifType > 0){
                return currNotifType
            } else{
                return 3
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notifType")
        }
    }
    static var cupCount: Int {
        get{
            let currCupCount = UserDefaults.standard.integer(forKey: "cupCount")
            if(currCupCount > 0 ){
                return currCupCount
            }
            else{
                return 0
            }
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "cupCount")
        }
    }
    static var notifText: String {
        get{
            let currNotifText = UserDefaults.standard.string(forKey: "notifText")
            if(currNotifText != nil){
                //exists
                return currNotifText!
            } else{
                return "Drink Your Water"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notifText")
        }
    }
    static var subText: String {
        get{
            let currSubText = UserDefaults.standard.string(forKey: "subText")
            if(currSubText != nil){
                //exists
                return currSubText!
            } else{
                return "Reminder to drink your water"
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "subText")
        }
    }
    static var showDockIcon: Bool {
        get {
            let currShowDockIcon = UserDefaults.standard.bool(forKey: "showDockIcon")
            if(currShowDockIcon == true){
                return currShowDockIcon
            } else{
                return false
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "showDockIcon")
        }
    }
    static func resetToDefault(){
        Preferences.reminderTime = 60 * 60 * 2
        Preferences.resetTime = "7:00"
//        Preferences.cupCount = 0 //Check if necessary
        Preferences.notifText = "Drink Your Water"
        Preferences.subText = "Reminder to drink your water"
        Preferences.showDockIcon = false
        print("Reset to default")
    }
}

