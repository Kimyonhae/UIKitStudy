import Foundation

struct ScheduleItem: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let dateText: String
    let participants: [String]   // IonName
    let isCompleted: Bool
}

extension ScheduleItem {
    
    static let mockData: [ScheduleItem] = [
        ScheduleItem(
            id: UUID(),
            title: "Client Review & Feedback",
            subtitle: "Crypto Wallet Redesign",
            dateText: "Today 10:00 PM – 11:45 PM",
            participants: ["person.circle", "person.circle"],
            isCompleted: true
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Create Wireframe",
            subtitle: "Crypto Wallet Redesign",
            dateText: "Today 09:15 PM – 10:00 PM",
            participants: ["person.circle", "person.circle", "person.circle"],
            isCompleted: true
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Review with Client",
            subtitle: "Product Team",
            dateText: "Today 01:00 PM – 03:00 PM",
            participants: ["person.circle", "person.circle", "person.circle"],
            isCompleted: false
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Design System Update",
            subtitle: "Mobile Team",
            dateText: "Tomorrow 11:00 AM – 12:30 PM",
            participants: ["person.circle", "person.circle"],
            isCompleted: false
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Sprint Planning",
            subtitle: "Development Team",
            dateText: "Tomorrow 02:00 PM – 04:00 PM",
            participants: ["person.circle", "person.circle", "person.circle"],
            isCompleted: false
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "UI Polish",
            subtitle: "Crypto Wallet Redesign",
            dateText: "Mar 12 04:00 PM – 06:00 PM",
            participants: ["person.circle"],
            isCompleted: true
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Backend API Review",
            subtitle: "Server Team",
            dateText: "Mar 13 10:00 AM – 11:00 AM",
            participants: ["person.circle", "person.circle"],
            isCompleted: false
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "User Testing",
            subtitle: "UX Research",
            dateText: "Mar 14 03:00 PM – 05:00 PM",
            participants: ["person.circle", "person.circle", "person.circle"],
            isCompleted: false
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Marketing Sync",
            subtitle: "Marketing Team",
            dateText: "Mar 15 01:00 PM – 02:00 PM",
            participants: ["person.circle", "person.circle"],
            isCompleted: true
        ),
        
        ScheduleItem(
            id: UUID(),
            title: "Release Preparation",
            subtitle: "Product Team",
            dateText: "Mar 16 05:00 PM – 07:00 PM",
            participants: ["person.circle", "person.circle", "person.circle"],
            isCompleted: false
        )
    ]
}
