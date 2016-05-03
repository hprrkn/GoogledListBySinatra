create table words(
  id integer primary key,
  wordtitle text,
  memo text,
  created_at,
  updated_at
);

insert into words(id, wordtitle, memo, created_at, updated_at) values (1, "word1", "memo1", current_timestamp, current_timestamp);
insert into words(id, wordtitle, memo, created_at, updated_at) values (2, "word2", "memo2", current_timestamp, current_timestamp);
insert into words(id, wordtitle, memo, created_at, updated_at) values (3, "word3", "memo3", current_timestamp, current_timestamp);


create table tags(
  id integer primary key,
  tagname text,
  created_at,
  updated_at
);

insert into tags(id, tagname, created_at, updated_at) values (1, "tag1", current_timestamp, current_timestamp);
insert into tags(id, tagname, created_at, updated_at) values (2, "tag2", current_timestamp, current_timestamp);
insert into tags(id, tagname, created_at, updated_at) values (3, "tag3", current_timestamp, current_timestamp);
insert into tags(id, tagname, created_at, updated_at) values (4, "tag4", current_timestamp, current_timestamp);

create table tags_words(
  word_id integer,
  tag_id integer,
  created_at,
  updated_at
);
