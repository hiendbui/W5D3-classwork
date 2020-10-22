-- PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    reply_id INTEGER,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (reply_id) REFERENCES replies(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id)
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (id, fname, lname)
VALUES
  (2, 'Josh', 'Bubar'),
  (1, 'Hien', 'Bui');

INSERT INTO
    questions (id, title, body, author_id)
VALUES
    (1, 'On Time', 'Does time pass?', 1),
    (2, 'Checkin', 'Did you eat?', 2);

INSERT INTO 
    question_follows (id, question_id, user_id)
VALUES 
    (1, 1, 2),
    (2, 2, 1),
    (3, 2, 2);

INSERT INTO 
    replies (id, body, question_id, reply_id, user_id)
VALUES 
    (1, 'Yes, time does pass', 1, nil, 2), 
    (2, "no, time is just another dimension", 1),
    (3, 2, 2);
