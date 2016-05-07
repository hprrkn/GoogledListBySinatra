create table users(
  id integer primary key,
  username text,
  password text,
  created_at,
  updated_at
);

create table words(
  id integer primary key,
  user_id integer,
  wordtitle text,
  memo text,
  created_at,
  updated_at
);

create table tags(
  id integer primary key,
  user_id integer,
  tagname text,
  created_at,
  updated_at
);

create table tags_words(
  word_id integer,
  tag_id integer,
  created_at,
  updated_at
);
