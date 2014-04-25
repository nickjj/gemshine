## What is gemshine?

Gemshine recursively searches a given path for all ruby projects and reports back a table showing the latest version of each gem you have installed in addition the version supplied by that project's Gemfile.

### What problem does it solve and why is it useful?

A typical rails project might have 40 or even 80 gems and keeping track of when a gem author updates each gem is painful.

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

**To check for updates with gemshine** involves the following awesome workflow:

1. Open a terminal.
2. Type `gemshine path /some/path` and enjoy the show.

### Example usage and output

After typing: `$ gemshine path /path/to/some/rails/app`

You would see a table similar to this:

```
+----------------------+------------+---------+
|                 awesomeapp                  |
+----------------------+------------+---------+
| Gem                  | Gemfile    | Latest  |
+----------------------+------------+---------+
| bootstrap-sass       | ~> 3.0.1   | 3.1.1.1 |
| bullet               | ~> 4.7.1   | 4.8.0   |
| coffee-rails         | ~> 4.0.1   | 4.0.1   |
| custom_configuration | ---------> | 0.0.2   |
| dotenv-rails         | ~> 0.9.0   | 0.11.1  |
| favicon_maker        | ~> 1.1.0   | 1.1.2   |
| font-awesome-rails   | ~> 4.0.3.1 | 4.0.3.1 |
| foreman              | >= 0.63.0  | 0.67.0  |
| jquery-rails         | ~> 3.0.4   | 3.1.0   |
| jquery-turbolinks    | ~> 2.0.1   | 2.0.2   |
| kaminari             | ~> 0.15.1  | 0.15.1  |
| meta_request         | ---------> | 0.3.0   |
| pg                   | ---------> | 0.17.1  |
| puma                 | ~> 2.7.1   | 2.8.2   |
| rack-mini-profiler   | ---------> | 0.9.1   |
| railroady            | ~> 1.1.1   | 1.1.1   |
| rails                | 4.0.3      | 4.1.0   |
| redis-rails          | ~> 4.0.0   | 4.0.0   |
| sass-rails           | ~> 4.0.1   | 4.0.3   |
| sdoc                 | ~> 0.4.0   | 0.4.0   |
| sidekiq              | ~> 2.17.4  | 3.0.0   |
| sinatra              | >= 1.3.0   | 1.4.5   |
| sitemap_generator    | ~> 4.3.1   | 5.0.2   |
| turbolinks           | ~> 1.3.1   | 2.2.2   |
| uglifier             | ~> 2.4.0   | 2.5.0   |
| whenever             | ---------> | 0.9.2   |
+----------------------+------------+---------+
| 26 total gems        |            |         |
+----------------------+------------+---------+
```

## Installation

`gem install gemshine`

## Commands

Here is an overview of the available commands. You can find out more information about each command and flag by simply
running `gemshine <command name> help` from your terminal. You can also type `gemshine` on its own to see a list of all commands.

- Get the latest gem versions for this project and compare them to your Gemfile's version
    - `gemshine path <PROJECT_PATH>`