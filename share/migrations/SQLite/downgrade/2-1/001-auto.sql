-- Convert schema '/Users/oliver/mydev/Moblo/share/migrations/_source/deploy/2/001-auto.yml' to '/Users/oliver/mydev/Moblo/share/migrations/_source/deploy/1/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE posts_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  author text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL
);

;
INSERT INTO posts_temp_alter( id, title, content, date_published) SELECT id, title, content, date_published FROM posts;

;
DROP TABLE posts;

;
CREATE TABLE posts (
  id INTEGER PRIMARY KEY NOT NULL,
  author text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL
);

;
INSERT INTO posts SELECT id, author, title, content, date_published FROM posts_temp_alter;

;
DROP TABLE posts_temp_alter;

;
DROP TABLE users;

;
DROP TABLE comments;

;

COMMIT;

