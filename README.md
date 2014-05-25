[![Gem Version](https://badge.fury.io/rb/gemshine.png)](http://badge.fury.io/rb/gemshine)

## What is gemshine?

Gemshine recursively searches a given path for all ruby projects and reports back a table showing the latest version of each gem you have installed in addition to the version you have installed locally for that project.

### What problem does it solve and why is it useful?

A typical rails project might have 40 or even 80 gems and keeping track of when a gem author updates each gem is painful. `bundle outdated` partly solves this problem but not quite.

**To check for updates manually without gemshine** involves the following excruciating workflow:

1. Open a path in your editor.
2. Open a web browser and visit [rubygems.org](http://www.rubygems.org).
3. Align them side by side.
4. Goto a project's Gemfile in your editor.
5. Search rubygems.org for the first gem in your list.
6. Glance at the latest version and compare it to your Gemfile's version.
7. Repeat this 1-100+ times depending on how many gems you have.
8. Move onto the next project in your path.
9. Repeat n times for each project you want to retrieve this information for.
10. Get up and look in the mirror to see if you can see your eye spasm after doing this workflow only once.

**To check for updates with bundle outdated instead of gemshine** involves the following boring workflow:

1. Open a terminal.
2. `cd` into a directory containing a Gemfile and type `bundle outdated`.
3. Mentally parse out the gems you probably don't care about (dependencies of dependencies).
4. Repeat step 2 and 3 until you are done checking all of your projects.
    - This is annoying when you have 15 rails projects to go through.

**To check for updates with gemshine** involves the following awesome workflow:

1. Open a terminal.
2. Type `gemshine path /some/path` and enjoy the show.

### Example usage and output

After typing: `$ gemshine path /path/to/some/rails/app`

You would see a table similar to this and it also color codes it based on how out of date the gems are:

```
+-------------------------+-----------------+----------------+-----------------+
|                                  awesomeapp                                  |
+-------------------------+-----------------+----------------+-----------------+
| Gem                     | Defined         | Installed      | Latest          |
+-------------------------+-----------------+----------------+-----------------+
| bootstrap-sass          | ~> 3.0.1        | 3.0.3.0        | 3.1.1.1         |
| bullet                  | ~> 4.7.1        | 4.7.1          | 4.8.0           |
| dotenv                  |                 | 0.9.0          | 0.11.1          |
| dotenv-rails            | ~> 0.9.0        | 0.9.0          | 0.11.1          |
| favicon_maker           | ~> 1.1.0        | 1.1.1          | 1.1.2           |
| font-awesome-rails      | ~> 4.0.3.1      | 4.0.3.1        | 4.0.3.2         |
| foreman                 |                 | 0.63.0         | 0.67.0          |
| jquery-rails            | ~> 3.0.4        | 3.0.4          | 3.1.0           |
| meta_request            |                 | 0.2.8          | 0.3.0           |
| puma                    | ~> 2.7.1        | 2.7.1          | 2.8.2           |
| rack-mini-profiler      |                 | 0.9.0          | 0.9.1           |
| rails                   | = 4.0.2         | 4.0.2          | 4.1.0           |
| sass                    |                 | 3.2.14         | 3.3.6           |
| sass-rails              | ~> 4.0.1        | 4.0.1          | 4.0.3           |
| sidekiq                 | ~> 2.17.4       | 2.17.4         | 3.0.0           |
| sinatra                 |                 | 1.4.4          | 1.4.5           |
| sitemap_generator       | ~> 4.3.1        | 4.3.1          | 5.0.2           |
| turbolinks              | ~> 1.3.1        | 1.3.1          | 2.2.2           |
| uglifier                | ~> 2.4.0        | 2.4.0          | 2.5.0           |
| whenever                |                 | 0.9.0          | 0.9.2           |
+-------------------------+-----------------+----------------+-----------------+
| 20 outdated gems        |                 |                |                 |
+-------------------------+-----------------+----------------+-----------------+
```

## Installation

`gem install gemshine`

## Commands

Here is an overview of the available commands. You can find out more information about each command and flag by simply
running `gemshine <command name> help` from your terminal. You can also type `gemshine` on its own to see a list of all commands.

- Get the latest gem versions for this project and compare them to your installed version
    - `gemshine path <PROJECT_PATH>`