CREATE TABLE IF NOT EXISTS students(
  id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255),
  password VARCHAR(255),
  name     VARCHAR(255),
  school   VARCHAR(255),
  age INTEGER,
  prefecture VARCHAR(255),
  day VARCHAR(255),
  gender VARCHAR(255),
  profile  TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
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
  gender VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS messages(
 id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
 title VARCHAR(255),
 message TEXT,
 studentid INTEGER,
 teacherid INTEGER,
 from_to   INTEGER,
 created_at TIMESTAMP
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
