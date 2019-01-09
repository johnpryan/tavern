A static site generator for blogs, written in Dart.

## Getting Started

Start with a normal dart project with the following structure:
 
    web/
      index.md
      templates/
        _index.mustache
    pubspec.yaml

Add tavern as a dependency in `pubspec.yaml`:

    name: my_awesome_blog
    dependencies:
      tavern: any
      build: any
    dev_dependencies:
      build_runner: any
      build_web_compilers: any

Edit `index.md`:

    ---
    title: Hello World!
    category: Random
    tags: ['code', 'dart']
    template: web/templates/_index.mustache
    ---

    foo

Edit `web/templates/_index.mustache`:

```
<html>
<head>
    <link rel="stylesheet" href="/style.css">
</head>
<body>
<div class="content">
    <h1>{{title}}</h1>
    <div id="content">
        {{{content}}}
    </div>
</div>
</body>
</html>
```

The `web/templates/_index.mustache` file is the mustache template that will be
applied to this page. Templates can use any metadata specified in the markdown
file.  For example:

