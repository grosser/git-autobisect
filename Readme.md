Find the first broken commit without having to learn git bisect.

 - automagically bundles if necessary
 - stops at first bad commit
 - starts slow (HEAD~1, HEAD~2, HEAD~3) then goes in steps of 10 (..., HEAD~10, HEAD~20, HEAD~30)

Install
=======

    gem install git-autobisect

Usage
=====

    cd your project
    # run a test that has a non-0 exit status
    git-autobisect 'rspec spec/models/user_spec.rb'
    ... grab a coffee ...
    ---> The first bad commit is a4328fa
    git show

TODO
====
 - go with 1 2 4 8 16 16 16 16 commits back
 - option for max-step -> if you think the problem is very fresh/very old

Development
===========
 - `bundle && bundle exec rake`
 - Tests run a lot faster without `bundle exec`

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/git-autobisect.png)](https://travis-ci.org/grosser/git-autobisect)
