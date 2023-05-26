import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    try app.register(collection: UserController())
    try app.register(collection: CategoryController())
    try app.register(collection: GroceryController())
}
