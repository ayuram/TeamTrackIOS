//
//  EventsList.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventsList: View {
    let data: DataModel
    @State var bool = false
    @State var confirmation = false
    @State var newEventName = ""
    @State var eventType = EventType.local
    init(){
        data = DataModel()
        data.localEvents.append(Event())
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
        if confirmation && newEventName != "" {
            data.localEvents.append(Event(newEventName))
            newEventName = ""
            confirmation = false
        }
        return NavigationView{
            ZStack{
                AlertControlView(textString: $newEventName, showAlert: $bool, confirmation: $confirmation, title: "New Event", message: "Enter a Name")
                VStack{
                    List{
                        Section(header: Text("Local Scrimmages")){
                            ForEach(data.localEvents){ event in
                                EventNav(event: event)
                            }
                        }
                        Section(header: Text("Virtual Tournaments")){
                            
                        }
                    }
                    
                }
            }
            
            .navigationBarTitle("Events")
            .navigationBarItems(trailing: Button("Add"){
                bool = true
            })
            
            .actionSheet(isPresented: $bool, content: {
                ActionSheet(title: Text("Add New Event"), message: Text("Select Event Type"), buttons: [
                    .default(Text("Local Scrimmage")) {eventType = .local},
                    .default(Text("Virtual Tournament")) {eventType = .virtual},
                    .cancel()
                ])
            })
        }
    }
}
struct AlertControlView: UIViewControllerRepresentable {
    @Binding var textString: String
    @Binding var showAlert: Bool
    @Binding var confirmation: Bool
    var title: String
    var message: String
    var virtualEvents = [VirtualEvent]()
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard context.coordinator.alert == nil else { return }
        if self.showAlert {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            context.coordinator.alert = alert
            alert.addTextField { textField in
                textField.placeholder = "Name"
                textField.text = self.textString
                textField.delegate = context.coordinator
            }
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive){ _ in
                if let textField = alert.textFields?.first, let _ = textField.text {
                    self.textString = ""
                }
                alert.dismiss(animated: true){
                    self.showAlert = false
                }
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default){ _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.textString = text
                }
                alert.dismiss(animated: true){
                    self.showAlert = false
                    self.confirmation = true
                    
                }
            })
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: {
                    showAlert = false
                    context.coordinator.alert = nil
                })
            }
        }
    }
    func makeCoordinator() -> AlertControlView.Coordinator{
        Coordinator(self)
    }
    class Coordinator: NSObject, UITextFieldDelegate{
        var alert: UIAlertController?
        var control: AlertControlView
        init(_ control: AlertControlView){
            self.control = control
        }
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
            if let text = textField.text as NSString? {
                self.control.textString = text.replacingCharacters(in: range, with: string)
            } else {
                self.control.textString = ""
            }
            return true
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
