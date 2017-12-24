# SqlFormatterWebInterface

## Installation

```ruby
gem install sql_formatter_web_interface
```

In your Gemfile:

```ruby
gem 'sql_formatter_web_interface'
```

Or, if you want to use `String#to_formatted_sql`:

```ruby
gem 'sql_formatter_web_interface', require: 'sql_formatter_web_interface/to_formatted_sql'
```

## Description
This library lets you write this:

```ruby
sql = <<-SQL
         select user_id, count(*) as how_many from bboard where
         not exists (select 1 from bboard_authorized_maintainers bam
         where bam.user_id = bboard.user_id) and posting_time + 60 > sysdate
         group by user_id order by how_many desc;
         SQL
SqlFormatterWebInterface.new(sql).format #=>
# SELECT user_id,
#        count(*) AS how_many
# FROM bboard
# WHERE NOT EXISTS
#     (SELECT 1
#      FROM bboard_authorized_maintainers bam
#      WHERE bam.user_id = bboard.user_id)
#   AND posting_time + 60 > sysdate
# GROUP BY user_id
# ORDER BY how_many DESC;
```

or this:

```ruby
sql = <<-SQL
         insert into customer (id, name) values (1, 'John');
         insert into customer (id, name) values (2, 'Jack');
         insert into customer (id, name) values (3, 'Jane');
         insert into customer (id, name) values (4, 'Jim');
         insert into customer (id, name) values (5, 'Jerry');
         insert into customer (id, name) values (1, 'Joe');
         SQL
SqlFormatterWebInterface.new(sql).format #=>
# INSERT INTO customer (id, name)
# VALUES (1,
#         'John');
#
# INSERT INTO customer (id, name)
# VALUES (2,
#         'Jack');
#
# INSERT INTO customer (id, name)
# VALUES (3,
#         'Jane');
#
# INSERT INTO customer (id, name)
# VALUES (4,
#         'Jim');
#
# INSERT INTO customer (id, name)
# VALUES (5,
#         'Jerry');
#
# INSERT INTO customer (id, name)
# VALUES (1,
#         'Joe');
```

or even this:

```ruby
require 'sql_formatter_web_interface/to_formatted_sql'
'select * from foo join bar on val1 = val2 where id = 123;'.to_formatted_sql(keyword_case: 'capitalize') #=>
# Select *
# From foo
# Join bar On val1 = val2
# Where id = 123;
```

Formatting happens making a request to an online SQL formatting service (https://sqlformat.org/api/ is the only supported at the moment).

## Usage

You can use `SqlFormatterWebInterface::format(sql, options)` or either `String#to_formatted_sql(options)`, where `options` is an hash with the options supported by the web service (see https://sqlformat.org/api/)

## License
MIT (see [LICENSE](LICENSE))
