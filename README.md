# Project 3 - *Tony's Awesome Twitter Client*

**Tony's Awesome Twitter Client** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [x] When composing, you should have a countdown in the ~~upper~~ lower right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [x] Customized *TweetView* class by extending from super class *UIView*, which is reusable
- [x] Tweeting and Replying to a tweet use the same *ComposeTweetViewController*, but the presentation for *Reply* is customized to show the original tweet so that the user has a context for writing their reply

To Do:
====
- [x] Place a backdrop/shadow view on the original tweet when the user is composing their reply, this will help them focus on their writing!
- [x] Add animations to the **Favorite** and **Retweet** buttons in Tweet Detail View, imitating the "popping" effect in the Twitter app

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Saving the user's access token in Keychain for security!
2. Adding pull from top and pull from bottom to refresh the table of tweets!

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](./screencast/screen2.gif)

## Notes

I was originally thinking about using **Alamofire** and the associates routes to make Twitter API calls after the user is authenticated through *OAuth*, because that way I can use the library **PromiseKit** when making asynch calls. However, that will take me more time and efforts, and given that my daughter is having her spring break from school, I would like to shift my time a bit for spending with her :icecream::tada:

## License

The MIT License
Copyright (c) [Tony Wang] https://github.com/rcholic/CodePath-TwitterClient

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
