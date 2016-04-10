create table words(
  id integer primary key,
  word text,
  memo text,
  created_at,
  updated_at
);

insert into words(id, word, memo, created_at, updated_at) values (1, "word1","memo1", current_timestamp, current_timestamp);
insert into words(id, word, memo, created_at, updated_at) values (2, "word2","memo2", current_timestamp, current_timestamp);
insert into words(id, word, memo, created_at, updated_at) values (3, "word3","memo3", current_timestamp, current_timestamp);


create table tags(
  id integer primary key,
  word_id integer,
  tag text,
  created_at,
  updated_at
);

insert into tags(id, word_id, tag, created_at, updated_at) values (1, 1, "tag1", current_timestamp, current_timestamp);
insert into tags(id, word_id, tag, created_at, updated_at) values (2, 1, "tag2", current_timestamp, current_timestamp);
insert into tags(id, word_id, tag, created_at, updated_at) values (3, 2, "tag3", current_timestamp, current_timestamp);
insert into tags(id, word_id, tag, created_at, updated_at) values (4, 3, "tag4", current_timestamp, current_timestamp);
