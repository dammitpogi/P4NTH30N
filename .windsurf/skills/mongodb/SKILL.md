# MongoDB Skill

This skill provides information about connecting to and using MongoDB with `mongosh`.

## Connection Pattern

To connect to a MongoDB instance using `mongosh`, you can use the following command:

```bash
mongosh "mongodb://<host>:<port>/<database>"
```

If the MongoDB instance is running on the default port (27017) on localhost, you can simply run:

```bash
mongosh
```

## Command-Line Options

`mongosh` supports the following command-line options:

| Option | Description |
|---|---|
| `--host` | The hostname of the MongoDB instance to connect to. |
| `--port` | The port of the MongoDB instance to connect to. |
| `--db` | The database to connect to. |
| `--username` | The username to use for authentication. |
| `--password` | The password to use for authentication. |
| `--authenticationDatabase` | The database to use for authentication. |
| `--tls` | Use TLS/SSL to connect to the MongoDB instance. |
| `--tlsCertificateKeyFile` | The path to the TLS/SSL certificate key file. |
| `--tlsCAFile` | The path to the TLS/SSL CA file. |
| `--eval` | Evaluate a JavaScript expression. |
| `--shell` | Run the shell after evaluating the script. |
| `--file` | Execute a JavaScript file. |
| `--version` | Show the `mongosh` version. |
| `--help` | Show the `mongosh` help. |

## Connecting to Deployments

### Connect to an Atlas Cluster

To connect to an Atlas cluster, you can use the connection string provided in the Atlas UI.

```bash
mongosh "mongodb+srv://<username>:<password>@<cluster-url>/<database>?retryWrites=true&w=majority"
```

### Connect to a Replica Set

To connect to a replica set, you must include the replica set name in the connection string.

```bash
mongosh "mongodb://<host1>:<port1>,<host2>:<port2>/<database>?replicaSet=<replica-set-name>"
```

## mongoshrc.js

The `mongoshrc.js` file is a JavaScript file that is executed when `mongosh` starts. You can use this file to customize your `mongosh` environment.

To use a `mongoshrc.js` file, you can place it in your home directory (`~/.mongoshrc.js`) or specify a path with the `--file` option.

## Exit Codes

| Code | Description |
|---|---|
| 0 | Success |
| 1 | An error occurred |

## CRUD Operations

### Create

To insert a single document into a collection, use `insertOne()`:

```javascript
db.collection('mycollection').insertOne({ name: 'test', value: 1 });
```

To insert multiple documents, use `insertMany()`:

```javascript
db.collection('mycollection').insertMany([
  { name: 'test1', value: 1 },
  { name: 'test2', value: 2 }
]);
```

### Read

To find a single document, use `findOne()`:

```javascript
db.collection('mycollection').findOne({ name: 'test' });
```

To find multiple documents, use `find()`:

```javascript
db.collection('mycollection').find({ value: { $gt: 1 } });
```

### Update

To update a single document, use `updateOne()`:

```javascript
db.collection('mycollection').updateOne(
  { name: 'test' },
  { $set: { value: 2 } }
);
```

To update multiple documents, use `updateMany()`:

```javascript
db.collection('mycollection').updateMany(
  { value: { $lt: 2 } },
  { $set: { value: 2 } }
);
```

### Delete

To delete a single document, use `deleteOne()`:

```javascript
db.collection('mycollection').deleteOne({ name: 'test' });
```

To delete multiple documents, use `deleteMany()`:

```javascript
db.collection('mycollection').deleteMany({ value: { $lt: 2 } });
```
