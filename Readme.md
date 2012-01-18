Find the first broken commit without having to learn git bisect

Install
=======

    sudo su # or use a location you do not need sudo for ...
    TO=/usr/local/bin/git-autobisect
    curl https://raw.github.com/grosser/git-autobisect/master/git-autobisect.sh > $TO
    chmod +x $TO

Usage
=====

    cd your project
    # run a test that has a non-0 exit status
    git-autobisect rspec spec/models/user_spec.rb
    ... grab a coffee ...
    ---> The first bad commit is a4328fa

    git checkout a4328fa
    git blame spec/models/user_spec.rb

TODO
====
 - support complex commands like 'sleep 0.1 && test -e a'
 - always checkout the first bad commit
 - --step option that lets you skip multiple commits when searching for a very old problem
 - option to square step on each successful test (skip 1 2 4 8 ... commits)


Test / Development
====

    git clone git://github.com/grosser/git-autobisect.git
    install ruby + rspec
    rspec spec

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
