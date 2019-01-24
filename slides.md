# Multiple Data Sources
### Diverse data for your tableviews

## DataSource & Delegate

`UITableViewDataSource` manages things like:

* `func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int`
* `func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell`

> The UITableViewDataSource protocol is adopted by an object that mediates the application’s data model for a UITableView object. The data source provides the table-view object with the information it needs to construct and modify a table view.
-- Apple Developer Documentation

`UITableViewDelegate` manages things like:

* `func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)`

> The delegate of a UITableView object must adopt the UITableViewDelegate protocol. Optional methods of the protocol allow the delegate to manage selections, configure section headings and footers, help to delete and reorder cells, and perform other actions.
-- Apple Developer Documentation

---

> A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements. Any type that satisfies the requirements of a protocol is said to conform to that protocol.
-- [The Swift Programming Language book](https://www.swift.org)

---

## Configure DataSource

### Programmatically

`tableView.dataSource = // some object that conforms to the UITableViewDataSource protocol`

### In Interface Builder

![Interface builder outlet inspector showing datasource and delegate connections]()