import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// Configures your application
public func configure(_ app: Application) async throws {
	app.middleware = .init()
    // Error HTML pages or JSON responses
	app.middleware.use(CustomErrorMiddleware(environment: app.environment))
    // Serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    // sudo systemctl enable mariadb.service
    // sudo systemctl start mariadb.service
    // sudo mariadb
    // > CREATE DATABASE riyyi;
    // > GRANT ALL ON riyyi.*  TO  'riyyi'@'%'          IDENTIFIED BY '123' WITH GRANT OPTION;
    // > GRANT ALL ON riyyi.*  TO  'riyyi'@'localhost'  IDENTIFIED BY '123' WITH GRANT OPTION; // % does NOT match localhost!
    // > FLUSH PRIVILEGES;

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "riyyi",
        password: Environment.get("DATABASE_PASSWORD") ?? "123",
        database: Environment.get("DATABASE_NAME") ?? "riyyi",
        tlsConfiguration: nil // Local connections dont need encryption
    ), as: .mysql)

    app.migrations.add(CreateTodo())

    // Register routes
    try routes(app)
}
