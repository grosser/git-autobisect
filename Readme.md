Find the first broken commit without having to learn git bisect

Install
=======

    TO=/usr/local/bin/git-autobisect
    curl https://raw.github.com/grosser/git-autobisect > $TO
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
 - always checkout the first bad commit
 - --step option that lets you skip multiple commits when searching for a very old problem
 - option to square step on each successful test (skip 1 2 4 8 ... commits)


Test / Development
====

    clone the repo
    install ruby + rspec
    rspec spec

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
