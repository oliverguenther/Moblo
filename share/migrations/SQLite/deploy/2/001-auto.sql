-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Sep 21 23:25:57 2014
-- 

;
BEGIN TRANSACTION;
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  fullname text NOT NULL
);
CREATE UNIQUE INDEX users_username ON users (username);
--
-- Table: posts
--
CREATE TABLE posts (
  id INTEGER PRIMARY KEY NOT NULL,
  author_id integer NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX posts_idx_author_id ON posts (author_id);
--
-- Table: comments
--
CREATE TABLE comments (
  id INTEGER PRIMARY KEY NOT NULL,
  post_id integer NOT NULL,
  user_id integer NOT NULL,
  created_at datetime DEFAULT (datetime('now')),
  content text NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX comments_idx_user_id ON comments (user_id);
CREATE INDEX comments_idx_post_id ON comments (post_id);
COMMIT;
