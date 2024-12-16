CREATE TABLE authors (
  id BIGSERIAL PRIMARY KEY,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  name text NOT NULL,
  bio text
);
