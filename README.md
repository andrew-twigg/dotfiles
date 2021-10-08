# dotfiles

Settings for tooling.

## Vim

### Dependencies

Node and yarn for markdown preview.

#### Node & Yarn (Mac)

```sh
brew install yarn node
```

#### [Markdown lint](https://github.com/DavidAnson/markdownlint) (Mac)

Guide [here](https://qmacro.org/2021/05/13/notes-on-markdown-linting-1/) for getting this working in Vim.

```sh
brew install markdownlint-cli
```

### Setup Vim

This section describes how to setup vim using the config in dotfiles.

```sh
cd ~/

# Clone the dotfiles
git clone https://github.com/andrew-twigg/dotfiles.git

# Copy existing Vim config
cp ~/.vimrc ~/.vimrc.bak

# Copy in dotfiles
cp ~/dotfiles/.vimrc ~/.vimrc
cp ~/dotfiles/.markdownlintrc ~/.markdownlintrc
```
