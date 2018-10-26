# bumpitup

## Installation

1. `ln -sf ./bumpitup.rb /usr/local/bin/bumpitup`

### Requirements

- [Hub](https://github.com/github/hub) installed and setup (`brew install hub`)

### Configuration (optional)

Copy `.biu.example` to your home directory and source it in your profile. If
you don't create and source your own config file, then defaults will be used.

##### `BIU_BASE_DIR`

Base directory to search for local repos. If not set, it will default to using your home directory.

## Usage

1. Run it. (`bumpitup gem_name repo1 repo2 ...`)
