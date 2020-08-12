//
//  ContentView.swift
//  loginFireBase
//
//  Created by User on 11/08/2020.
//  Copyright © 2020 Alvin. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

// color FE3C72

struct ContentView: View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        //Navigation view
        NavigationView{
            VStack{
                if self.status{
                    HomeScreen()
                }
                else{
                    ZStack{
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            Text("")
                        }
                    .hidden()
                        Login(show: self.$show)
                    }
                }
            }
            
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
            .onAppear(){
                NotificationCenter.default.addObserver(forName: Notification.Name("status"), object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct HomeScreen : View{
    var body: some View{
        VStack{
            Text("Welcome").font(.title).fontWeight(.bold).foregroundColor(Color.black.opacity(0.7))
             Button(action: {
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: Notification.Name("status"),object: nil)
                                   
                }) {
                    Text("Sign out").fontWeight(.bold).foregroundColor(.white).padding(.vertical).frame(width: UIScreen.main.bounds.width - 50)
                    
             }
             .background(Color(.red))
             .cornerRadius(20)
             .padding(.top, 25)
        }
        .padding(.horizontal, 25)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View{
    var body: some View{
        VStack{
            
            Spacer()
        }
    }
    
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topTrailing){
            GeometryReader{_ in
                VStack{
                    Image(systemName: "person.circle")
                    Text("Log in to your account").font(.title).fontWeight(.bold).foregroundColor(self.color).padding(.top, 35)
                    
                    TextField("Email", text: self.$email).autocapitalization(.none).padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color(.red) : self.color,lineWidth: 2)).padding(.top, 25)
                    
                    HStack(spacing: 15){
                        
                        VStack{
                            if self.visible{
                                TextField("Password", text: self.$pass).autocapitalization(.none)
                            }
                            else {
                                SecureField("Password", text: self.$pass).autocapitalization(.none)
                            }
                        }
                        Button(action: {
                            self.visible.toggle()
                        }) {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").renderingMode(.original).foregroundColor(self.color)
                            
                        }
                    }
                    .padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color(.red) : self.color,lineWidth: 2)).padding(.top, 25)
                    
                    HStack{
                        //Placing spacers in horizontal stack algigns the item verticaly to the stack
                        Spacer()
                        Button(action: {
                            
                            self.reset()
                            
                        }) {
                            Text("Forgoten Password").fontWeight(.bold).foregroundColor(Color(.red))
                        }

                    }
                    Button(action: {
                        
                        self.verify()
                        
                    }) {
                        Text("Sign in").fontWeight(.bold).foregroundColor(.white).padding(.vertical).frame(width: UIScreen.main.bounds.width - 50)
                        
                    }
                    .background(Color(.red))
                .cornerRadius(20)
                    .padding(.top, 25)
                }
                .padding(.horizontal, 25)
            }
            Button(action: {
                self.show.toggle()
            }) {
                Text("Register").fontWeight(.bold).foregroundColor(.red)
            }
        .padding()
        }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
    
        }
    }
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res,
                                                                              err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("Success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("Status"), object: nil)
            }
            
        }
            else{
                self.error = "Please fill in all check fields correctly"
                self.alert.toggle()
        }
    }
    
    func reset(){
        if self.email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                self.error = "Reset"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Email id is empty"
            self.alert.toggle()
        }
    }
}


struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repas = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View{
        
        ZStack{
            ZStack(alignment: .topLeading){
                GeometryReader{_ in
                    VStack{
                        Image(systemName: "person.circle")
                        Text("Create your account").font(.title).fontWeight(.bold).foregroundColor(self.color).padding(.top, 35)
                        
                        TextField("Email", text: self.$email).autocapitalization(.none).padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color(.red) : self.color,lineWidth: 2)).padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                if self.visible{
                                    TextField("Password", text: self.$pass).autocapitalization(.none)
                                }
                                else {
                                    SecureField("Password", text: self.$pass).autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill").renderingMode(.original).foregroundColor(self.color)
                                
                            }
                        }
                            
                        .padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color(.red) : self.color,lineWidth: 2)).padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                if self.visible{
                                    TextField("Re-enter", text: self.$repas).autocapitalization(.none)
                                }
                                else {
                                    SecureField("Re-enter", text: self.$repas).autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill").renderingMode(.original).foregroundColor(self.color)
                                
                            }
                        }
                            
                        .padding().background(RoundedRectangle(cornerRadius: 4).stroke(self.repas != "" ? Color(.red) : self.color,lineWidth: 2)).padding(.top, 25)
                        
                        Button(action: {
                            self.register()
                        }) {
                            Text("Register").fontWeight(.bold).foregroundColor(.white).padding(.vertical).frame(width: UIScreen.main.bounds.width - 50)
                            
                        }
                        .background(Color(.red))
                    .cornerRadius(20)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                }
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left").font(.title).foregroundColor(.red)

                }
            .padding()
            }
            if self.alert{
                ErrorView(alert: self.$alert, error: $error)
            }
        }
        
        .navigationBarBackButtonHidden(true)
    }
    func register() {
        if self.email != ""{
            if self.pass == self.repas {
                Auth.auth().createUser(withEmail: self.email, password: self.pass) {
                    (res, err) in
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("Succesful")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
                
            }
            else{
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Please fill all checks"
            self.alert.toggle()
        }
    }
}

struct ErrorView: View {
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    var body: some View{
        GeometryReader{_ in
            
            VStack{
                HStack{
                    Text(self.error == "Reset" ? "Message" : "Error").font(.title).fontWeight(.bold).foregroundColor(self.color)
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.horizontal, 25)
                Text(self.error == "Reset" ? "Password reset link has been sent to your email" : self.error).foregroundColor(self.color).padding(.top)
                
                Button(action: {
                    self.alert.toggle()
                }) {
                    Text(self.error ==  "Reset" ? "Ok" : "Cancel").foregroundColor(.white).padding(.vertical).frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color.red)
            .cornerRadius(20)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
        .cornerRadius(15)
            
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}
