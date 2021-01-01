//
//  EventsList.swift
//  ScoutingApp
//
//  Created by Ayush Raman on 12/5/20.
//

import SwiftUI

struct EventsList: View {
    @EnvironmentObject var data: DataModel
    @State var bool = false
    @State var acSh = false
    @State var confirmation = false
    @State var newEventName = ""
    @State var eventType = EventType.local
    @State var titleString = ""
    init(){
        UITableView.appearance().backgroundColor = UIColor(Color("background"))
    }
    var body: some View {
       NavigationView{
            ZStack{
                AlertControlView(textString: $newEventName, showAlert: $bool, type: eventType, arr: getArray(of: eventType), title: "New Event", message: "Enter a name"){
                    data.saveEvents()
                }
                VStack{
                    List{
                        Section(header: Text("Local Scrimmages")){
                            ForEach(data.localEvents){ event in
                                EventNav(event: event)
                                    .environmentObject(data)
                            }
                            .onDelete(perform: { indexSet in
                                data.localEvents.remove(atOffsets: indexSet)
                                data.saveEvents()
                            })
                            .onMove(perform: { indices, newOffset in
                                data.localEvents.move(fromOffsets: indices, toOffset: newOffset)
                                data.saveEvents()
                            })
                        }
                        Section(header: Text("Virtual Tournaments")){
                            ForEach(data.virtualEvents){ event in
                                VirtualEventNav(event: event)
                                    .environmentObject(data)
                            }
                            .onDelete(perform: { indexSet in
                                data.virtualEvents.remove(atOffsets: indexSet)
                                data.saveEvents()
                            })
                            .onMove(perform: { indices, newOffset in
                                data.virtualEvents.move(fromOffsets: indices, toOffset: newOffset)
                                data.saveEvents()
                            })
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                }
            }
            .navigationBarTitle("Events")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add"){
                acSh = true
            })
            .actionSheet(isPresented: $acSh, content: {
                ActionSheet(title: Text("Add New Event"), message: Text("Select Event Type"), buttons: [
                    .default(Text("Local Scrimmage")) {eventType = .local; titleString = "New Local Event"; bool = true},
                    .default(Text("Virtual Tournament")) {eventType = .virtual; titleString = "New Virtual Event"; bool = true},
                    .cancel()
                ])
            })
        }
    }
    func getArray(of type: EventType) -> Binding<[Event]> {
        switch type{
        case .local: return $data.localEvents
        case .virtual: return $data.virtualEvents
        case .live: return $data.liveEvents
        }
    }
    func sheet() -> some View{
        NavigationView{
            VStack{
                TextField("Event Name", text: $newEventName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .navigationBarItems(leading: Button("Cancel"){
                bool = false
                newEventName = ""
            }, trailing: Button("Save"){
                if(eventType == .local){
                    data.localEvents.append(Event(newEventName, type: .local))
                } else if eventType == .virtual {
                    data.virtualEvents.append(Event(newEventName, type: .virtual))
                }
                data.saveEvents()
                newEventName = ""
                bool = false
            })
        }
    }
}
struct AlertControlView: UIViewControllerRepresentable {
    @Binding var textString: String
    @Binding var showAlert: Bool
    let type: EventType
    @Binding var arr: [Event]
    var title: String
    var message: String
    var function: () -> Void
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
                    self.textString = ""
                }
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default){ _ in
                if let textField = alert.textFields?.first, let text = textField.text {
                    self.textString = text
                }
                alert.dismiss(animated: true){
                    self.showAlert = false
                    arr.append(Event(textString, type: type))
                    function()
                    self.textString = ""
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
            .preferredColorScheme(.dark)
            .environmentObject(DataModel())
    }
}
