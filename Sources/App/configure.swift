import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Database setup
    try app.databases.use(.postgres(url: "postgres://mvofhhql:AIs5MHoy8rQUmofq10IX0dDoJuJaw7pJ@mahmud.db.elephantsql.com/mvofhhql"), as: .psql)
    
    // Migrations
    app.migrations.add(CreateUserMigration())
    app.migrations.add(CreateCategoriesMigration())
    
    app.jwt.signers.use(.hs256(key: "SECRETKEYHERE"))
    
    // register routes
    try routes(app)
}
