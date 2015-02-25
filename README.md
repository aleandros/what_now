what_now
========

Executable (packed as a ruby gem) for finding TODO comments inside code
Requires Ruby 1.9.* and above


Installation
---------
If you use rbenv or RVM:
```
gem install what_now
```
Otherwise you might need
```
sudo gem install what_now
```


Usage
-----
```
$ wnow
```
Will return all the todos in the following format inside files:

* TODO this is the text

Where 'this is the text' will be returned, together with the relative path and line number

The output is colored, but if redirected to a non TTY device, a simpler, colorless format
will be used.

Options
-------
* *--dir, -d*: Specify the directory in which to search the TODO's. It can be an absolute
  path of anyhwere in the system, or a relative path to the current directory.
* *--ext, -e*: Specify the extension of the files to consider. You can pass it with or without
  the dot (.rb or rb are both valid).
* *--regex, -r*: Specify the regular expression (Perl-like) that the file names
  must match.
* *--ignorecase, -i*: When passed, this options matches both the strings *TODO* and *todo*.
  By default, this options is deactivated.
