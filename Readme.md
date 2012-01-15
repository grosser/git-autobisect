Find the broken commit without having to learn git bisect

Install
=======
    curl https://raw.github.com/grosser/git-autobisect > /usr/local/bin/git-autobisect
    chmod +x /usr/local/bin/git-autobisect

Usage
=====

    cd your project
    git-autobisect rspec spec/models/user_spec.rb:12
    ... grab a coffee ...
    -> The first bad commit is a4328fa

Test
====

    clone the repo
    install git + ruby + rspec
    rspec spec


Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
