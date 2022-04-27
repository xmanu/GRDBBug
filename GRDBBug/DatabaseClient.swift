//
//  DatabaseClient.swift
//  GRDBBug
//
//  Created by Manuel Weiel INVERS GmbH on 27.04.22.
//
import Foundation
import GRDB

public struct DatabaseClient {
    // MARK: Lifecycle

    public init(_ databaseWriter: DatabaseWriter) throws {
        self.databaseWriter = databaseWriter
        try migrator.migrate(databaseWriter)
    }

    // MARK: Public

    public static let shared = makeShared()

    public static func dbUrl() throws -> URL {
        // Create a folder for storing the SQLite database, as well as
        // the various temporary files created during normal database
        // operations (https://sqlite.org/tempfiles.html).
        let fileManager = FileManager()
        let folderURL = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("database", isDirectory: true)
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

        // Connect to a database on disk
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        return folderURL.appendingPathComponent("db.sqlite")
    }

    // MARK: Internal

    let databaseWriter: DatabaseWriter

    // MARK: Private
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("INITIAL") { db in
            try db
                .create(
                    table: Player.databaseTableName,
                    temporary: false,
                    ifNotExists: true,
                    body: { table in
                        table.column(Player.Columns.id.name, .text)
                            .primaryKey(onConflict: .replace, autoincrement: false)
                        table.column(Player.Columns.name.name, .text)
                    }
                )
        }
        
        return migrator
    }

    private static func makeShared() -> DatabaseClient {
        do {
            let dbPool = try DatabasePool(path: Self.dbUrl().path, configuration: Configuration())

            // Create the AppDatabase
            return try DatabaseClient(dbPool)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
}
