create table users(
  id integer primary key,
  username text,
  password text,
  created_at,
  updated_at
);

insert into users (id, username, password, created_at, updated_at) values (1, "test", "test", current_timestamp, current_timestamp);

create table words(
  id integer primary key,
  user_id integer,
  wordtitle text,
  memo text,
  created_at,
  updated_at
);

insert into words(id, user_id, wordtitle, memo, created_at, updated_at) values (1, 1, "word1", "memo1", current_timestamp, current_timestamp);
insert into words(id, user_id, wordtitle, memo, created_at, updated_at) values (2, 1, "word2", "memo2", current_timestamp, current_timestamp);
insert into words(id, user_id, wordtitle, memo, created_at, updated_at) values (3, 1, "word3", "memo3", current_timestamp, current_timestamp);


create table tags(
  id integer primary key,
  user_id integer,
  tagname text,
  created_at,
  updated_at
);

insert into tags(id, user_id, tagname, created_at, updated_at) values (1, 1, "tag1", current_timestamp, current_timestamp);
insert into tags(id, user_id, tagname, created_at, updated_at) values (2, 1, "tag2", current_timestamp, current_timestamp);
insert into tags(id, user_id, tagname, created_at, updated_at) values (3, 1, "tag3", current_timestamp, current_timestamp);
insert into tags(id, user_id, tagname, created_at, updated_at) values (4, 1, "tag4", current_timestamp, current_timestamp);

create table tags_words(
  word_id integer,
  tag_id integer,
  created_at,
  updated_at
);
