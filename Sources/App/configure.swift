import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Database setup
    try app.databases.use(.postgres(url: "postgres://mvofhhql:AIs5MHoy8rQUmofq10IX0dDoJuJaw7pJ@mahmud.db.elephantsql.com/mvofhhql"), as: .psql)
    
    // Migrations
    app.migrations.add(CreateUserMigration())
    
    // register routes
    try routes(app)
}
