-- Convert schema '/Users/oliver/mydev/Moblo/share/migrations/_source/deploy/1/001-auto.yml' to '/Users/oliver/mydev/Moblo/share/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE comments (
  id INTEGER PRIMARY KEY NOT NULL,
  post_id integer NOT NULL,
  user_id integer NOT NULL,
  created_at datetime DEFAULT (datetime('now')),
  content text NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE
);

;
CREATE INDEX comments_idx_user_id ON comments (user_id);

;
CREATE INDEX comments_idx_post_id ON comments (post_id);

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  fullname text NOT NULL
);

;
CREATE UNIQUE INDEX users_username ON users (username);

;
CREATE TEMPORARY TABLE posts_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  author_id integer,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create legacy user 'foo' to cover posts from first revision
INSERT INTO users (username, pw_hash, fullname) VALUES('foo', '--INVALID--', 'Legacy Author');
-- Copy old posts
INSERT INTO posts_temp_alter( id, title, content, date_published) SELECT id, title, content, date_published FROM posts;
-- Set legacy author
UPDATE posts_temp_alter SET author_id = (select id from users where users.username = "foo" LIMIT 1);


;
DROP TABLE posts;

;
CREATE TABLE posts (
  id INTEGER PRIMARY KEY NOT NULL,
  author_id integer NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX posts_idx_author_id02 ON posts (author_id);
INSERT INTO posts SELECT id, author_id, title, content, date_published FROM posts_temp_alter;
DROP TABLE posts_temp_alter;
COMMIT;

