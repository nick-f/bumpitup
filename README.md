# bumpitup

## Requirements
- [Hub](https://github.com/github/hub) installed and setup (`brew install hub`)

## Configuration (optional)

Copy `.biu.example` to your home directory and source it in your profile. If
you don't create and source your own config file, then defaults will be used.

### `BIU_BASE_DIR`
Base directory to search for local repos. If not set, it will default to using your home directory.

## Installation
1. Clone the repo and change into it.
1. `ln -sf `pwd`/bumpitup.rb /usr/local/bin/bumpitup`

## Usage
```
bumpitup gem_name repo
```

You can specify multiple repos to update.

```
bumpitup gem_name repo1 repo2
```
