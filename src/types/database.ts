export enum DatabaseType {
  PostgreSQL = 'postgresql',
  MySQL = 'mysql',
  SQLite = 'sqlite',
  MongoDB = 'mongodb',
  Redis = 'redis',
  SQLServer = 'sqlserver',
  ClickHouse = 'clickhouse',
  TDengine = 'tdengine',
}

export interface DatabaseConnection {
  id: string;
  name: string;
  type: DatabaseType;
  host?: string;
  port?: number;
  database?: string;
  username?: string;
  password?: string;
  ssl?: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export interface ConnectionStatus {
  id: string;
  connected: boolean;
  message?: string;
}
