Find the first broken commit without having to learn git bisect.

 - automagically bundles if necessary
 - stops at first bad commit
 - takes binary steps (HEAD~1, HEAD~2, HEAD~4, HEAD~8)

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

### Options

    -m, --max N                    Inspect commits between HEAD..HEAD~<max>
    -s, --start N                  Use N (instead of 1) as initial step and keep muliplying by 2
    --no-bundle                    Do not bundle even if a Gemfile exists

TIPS
====
 - do not fail if test file is missing `[ ! -f spec/my_spec.rb ] || rspec spec/my_spec.rb`

TODO
====
 - option for max-step-size so you can use a finer grained approach
 - option to disable `bundle check || bundle` injection
 - option to consider a build failed if it finishes faster then x seconds

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
