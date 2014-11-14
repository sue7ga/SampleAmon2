CREATE TABLE IF NOT EXISTS students(
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255),
  password VARCHAR(255),
  name     VARCHAR(255),
  school   VARCHAR(255),
  profile  TEXT
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS teachers(
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255),
  password VARCHAR(255),
  name     VARCHAR(255),
  school   VARCHAR(255),
  age INTEGER,
  prefecture VARCHAR(255),
  income INTEGER,
  day VARCHAR(255),
  teaching VARCHAR(255),
  profile  TEXT,
  created_at INTEGER,
  updated_at INTEGER
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
