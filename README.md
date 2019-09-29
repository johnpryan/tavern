A static site generator for blogs with Dart support

## Getting Started

Start with an empty project and add the following files:
 
 ```txt
web/
  index.md
  templates/
    _index.mustache
pubspec.yaml
 ```

Add tavern as a dependency in `pubspec.yaml`:

```yaml
name: my_awesome_blog
dependencies:
  tavern: ^3.0.0
  build: any
dev_dependencies:
  build_runner: any
  build_web_compilers: any
```

Edit `index.md`:

```md

---
title: Hello World!
category: Random
tags: ['code', 'dart']
template: web/templates/_index.mustache
---

foo

```

Edit `web/templates/_index.mustache`:

```html
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

## Developing

Fetch the projects dependencies:

```bash
pub get
```

Run build_runner:

```bash
pub run build_runner serve
```

## Releasing

To build the static files for deployment, use the `build` command with the
`--release` flag:

```bash
pub run build_runner build --release --output build
```

## Websites built with Tavern

- [Ellen Skiff Design](https://ellenskiff.com)
    - [Source Code](https://github.com/ellenskiff/skiff)

## Dart 1
See https://github.com/johnpryan/tavern-dart1 for the old Dart 1 compatible
version of this project