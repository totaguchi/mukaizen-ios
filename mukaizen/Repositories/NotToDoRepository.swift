import Foundation

protocol NotToDoRepository {
    func addItem(_ item: NotToDoItem)
    func updateItem(_ item: NotToDoItem)
    func deleteItem(_ item: NotToDoItem)
    func addRecord(_ record: Record, to item: NotToDoItem)
    func deleteRecord(_ record: Record)
}
