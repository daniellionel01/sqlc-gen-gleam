CREATE TABLE authors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  name TEXT NOT NULL,
  bio TEXT
);
