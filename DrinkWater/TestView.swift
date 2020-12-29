//
//  TestView.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/29/20.
//

import SwiftUI

struct TestView: View {
    @available(OSX 10.15.0, *)
    var body: some View {
        Menu(/*@START_MENU_TOKEN@*/"Menu"/*@END_MENU_TOKEN@*/) {
            /*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
            /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
            /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
        }
    }
}

struct TestView_Previews: PreviewProvider {
    @available(OSX 10.15.0, *)
    static var previews: some View {
        TestView()
    }
    
}
