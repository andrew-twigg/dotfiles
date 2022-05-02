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

On Ubuntu:

```sh
npm install -g markdownlint-cli
```

On MacOS:

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

#### Code Completion

YouCompleteMe provides the code completion.

The C# completer is added as parameter to the install. Via [OmniSharp](https://github.com/OmniSharp/omnisharp-vim) and [Roslyn server](https://github.com/OmniSharp/omnisharp-roslyn). The Vim OmniSharp plugin comes from the [.vimrc](https://github.com/andrew-twigg/dotfiles/blob/master/.vimrc). The server will install automatically when you open a C# file or you can upgrade it with :OmniSharpInstall.

> Note: ***Apple Silicon*** - On Apple Silicon, YCM doesn't like the miniforge Python version. Had to force it to use the version of Python installed at /opt/homebrew/bin/python3.

```sh
mkdir ~/.omnisharp
cp ~/dotfiles/.omnisharp/omnisharp.json ~/.omnisharp/omnisharp.json
```

> Note: Not sure how OmniSharp Roslyn extensions locations paths in omnisharp.json were populated, sounds like they are [automatically discovered](https://www.strathweb.com/2019/04/roslyn-analyzers-in-code-fixes-in-omnisharp-and-vs-code/). I think they came from the VS Code extension install. So the **LocationPaths** are empty, but if they don't populate then this is where they were:
>
> ```sh
> "/Users/andrew/.vscode/extensions/josefpihrt-vscode.roslynator-3.2.2/roslyn/common",
> "/Users/andrew/.vscode/extensions/josefpihrt-vscode.roslynator-3.2.2/roslyn/analyzers",
> "/Users/andrew/.vscode/extensions/josefpihrt-vscode.roslynator-3.2.2/roslyn/refactorings",
> "/Users/andrew/.vscode/extensions/josefpihrt-vscode.roslynator-3.2.2/roslyn/fixes"
> ```

### Javascript Coding

The .vimrc includes:

* dense-analysis/ale for fixers and linters
* ycm-core/YouCompleteMe with --ts-completer for code completion
* puremourning/vimspector with --force-enable-node for debugging

For fixers and linters, in the root of the project...

```sh
npm install eslint --save-dev
npx eslint --init
```

For debugging...

```sh
cp .vimspector.json <project root>
```
