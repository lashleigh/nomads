Ashleigh and Benson's bicycling log.

http://nomad.heroku.com

This project is not a good place to start learning about rails. It was my
very first website and I didn't write tests or comments anywhere. That said,
it has some neat aspects and I welcome anyone who wants to use it.

What follows are some directions about how to modify this repo so it could
be used for your own bicycle tour. Please don't hesitate to suggest/request
clarification.

clone or fork the repo and cd into it. Then run:

    bundle install
    rake db:create
    rake db:migrate
    rails s 

open up http://localhost:3000/

Log yourself in by clicking the sign in link and 
supplying openid credentials. Now you need to make
yourself an admin so you can write posts

In the root directory type:

    rails c
    u = User.first 
    u.admin = true
    u.save

Go back to `http://localhost:3000/posts`, you should
see a 'New Post' link. Click on it and supply some dummy content.
Check the 'published' box at the bottom of the page and click save.

You should be redirected to localhost:3000/posts/1-your-posts-awesome-title

Notice the map to the right. Drag the icon around. Every time you stop dragging
the geolocation of the post gets updated. Every new post defaults to the location
of your previous post, with the exception of the first one which defaults to Seattle.

Go to the map tab and check that your post is on the map. If you don't see your
post double check that you checked the 'published' box. 

Before you can start leaving yourself suggestions we need to save the
suggestion types to the database. The suggestion types are really just
the names of the icons you wish to use. 

In your rails console paste in the following

    [{"name"=>"see", "description"=>"A place to visit or something to see"}, 
     {"name"=>"camp", "description"=>"A place to camp"}, 
     {"name"=>"eat", "description"=>"A place to eat"}, 
     {"name"=>"stay", "description"=>"A place where we can sleep indoors"}, 
     {"name"=>"avoid", "description"=>"Stay away!"}, 
     {"name"=>"misc", "description"=>"Something that does not fit in the other categories"}, 
     {"name"=>"blog", "description"=>"A blog post"}, 
     {"name"=>"image", "description"=>"A picture from the road"}].each {|icon| Icon.create(icon) }

Now refresh the map tab. You should see several icons, these are the default suggestion types. 
Try clicking the word `suggestion` and following the directions. Choose a location on the map for
your suggestion then describe it a bit and click save.

Now it's time to actually edit some code and make this repository reflect your story instead of
mine. 

## Twitter tab customization
On the home page there is a twitter feed off to the right. You can make that
point at your own twitter by editing `app/views/home/_twitter.html.erb`
There were two of us traveling together when I made this website and we
wanted both of our tweets to show up so we made a list that only had the two
of us in it. 

## Flickr tab customization
Start by editing the links at `app/views/home/_flickr.html.erb` to point to your
own flickr profile. 

The second part of how I used flickr was a cron task located at: `lib/task/cron.rake`
The cron task is currently set up to grab flickr photos with the `nomad` tag
from two users (Benson and I by default). 
Edit this file to have your flickr user id. You can look up your flickr id here: http://idgettr.com/

Go to flickr and tag a couple of your geolocated photos with `nomad`.

In the root directory of the project run: 

    rake flick:update

Now when you visit the map tab you should see icons for your photos. There
should also be thumbnails at the photos tab and at the home view. 

## About tab customization
You'll want to edit the about page heavily. It is currently hard coded html
all of which is located at `app/views/home/about.html.erb`

# Ready to deploy
This should have been enough to get you in a deployable state. I'll take you through deploying
the app to heroku now. Heroku is deprecating the `heroku` gem sadly enough so grab a copy of
the heroku toolbelt here: https://toolbelt.heroku.com/

The basic heroku getting started instructions are also worth reading though:

https://devcenter.heroku.com/articles/rails3

tl;dr

Make sure you have committed all of your changes.  Then this should take care of it:

    heroku login 
    heroku create
    git push heroku master
    heroku db:push # You will be prompted to enter the absurd name of your app
    heroku open

If anything goes weird during the heroku deploy just google part of the error message. You are 
almost guaranteed to find multiple answers/articles on every possible heroku bug. You may of
course open an issue here, but google will probably be faster. 


## WARNINGS
Be advised that the map suggestion names map directly to the icons in `/public/images/map_icons/`
If you change the names in the database be sure to change the name
of the corresponding image to match. Similarly if you want to add a new icon all
you have to do is save it in the database and create an image by the same name.

When people leave suggestions the type is stored in the database via the `icon_id`,
be careful deleting icons after your project is public. You'll need to reassign the
`icon_id` for the effected suggestions. 


## TODO
* extract and centalize configs
 - flickr
 - twitter
 - various `consumer_keys`

* maps fail to load when posts array is empty
* icons
 - maybe replace Icon table with a yaml file and key suggestion type
   off of the name instead of the `icon_id`
* heroku toolbelt
 - Other handy commands that you probably won't need at the moment
 - heroku run rake db:migrate
 - heroku run rake flickr:update


