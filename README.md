# Introduction

SimpleCI is a lightweigth continuous integration application build with [Sinatra](https://github.com/sinatra/sinatra).

It handles both Git and Mercurial repositories (local and remote) and support activation by HTTP POST request.

You can hook it into other things like an IRC bot ([Bishop](https://github.com/ta/bishop) supports this out of the box) by providing an URL for the Post-Build Hook. 

# Installation

    $ git clone git://github.com/ta/simpleci.git
    $ cd simpleci
    $ bundle install
    $ export DATABASE_URL=sqlite3:///tmp/simpleci.db
    $ bundle exec rake db:migrate
    $ bundle exec unicorn

At this time you can open [http://localhost:8080](http://localhost:8080) in your browser and sign in with username "admin@domain.tld" and password "abcd1234" - You might want to change those!

# Demo

You can watch simpleci testing itself at [https://simpleci.herokuapp.com](https://simpleci.herokuapp.com) - log in with username "demo@domain.tld" and password "1234abcd". The user does not have administrator privileges. For that you need to run your own instance of simpleci as described in the Installation section.

# Licence

Copyright (c) 2012 Tonni Aagesen

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.