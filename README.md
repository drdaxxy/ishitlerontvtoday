# Is Hitler On TV Today?

This is a project to analyse visibility of national socialism on German TV. (No, I do not support them, I dislike Nazis as much as you do.).
An attached cronjob feeds EPG data from a TV card into a database, and a web application allows me to mark shows as related or unrelated to Nazism.
[ishitlerontvtoday.com](http://ishitlerontvtoday.com) shows whether there are any relevant shows for the present day.
The project also includes a twitterbot that tweets the count of Nazi shows for the day.

After about a year, I will analyse the data collected and post my results on the aforementioned site.

Some of the code in this project may also be useful for more productive uses of EPG data.

## License

See LICENSE.

## Installation

If you want to set up your own instance of ishitlerontvtoday.com, these are the steps.
* Install Ruby. Tested with 1.9, other versions may or may not work.
* `gem install bundler`
* `bundle install --deployment`
* Copy `config.rb.example` to `config.rb` and make the necessary changes. You do not need to set Twitter details if you are not going to use the Twitter bot, or `:secret` if you are not going to use the admin functionality.
* If you want automatic import of EPG data, adjust `cron.rb` and add it to your crontab. Warning: takes hours to run, and executes hundreds of thousands of queries individually, so it takes even longer againt a remote database server. Note you'll have to run the script with `RACK_ENV='production'` if you want to use production settings.
* Add `twitterbot.rb` to your crontab if you want automatic Twitter updates. Same note about the Rack environment applies.
* Run the web application as you would run any other Rack app. `ruby main.rb` will work for development/testing, but for public use, you'll want to set up a proper webserver.