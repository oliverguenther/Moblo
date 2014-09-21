-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Sep 21 22:30:49 2014
-- 

;
BEGIN TRANSACTION;
--
-- Table: posts
--
CREATE TABLE posts (
  id INTEGER PRIMARY KEY NOT NULL,
  author text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL
);
COMMIT;
