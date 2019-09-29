## install_vs_code_golang_ext_tools 

安装 VS Code Go语言插件所需要的工具。适用于Go语言版本大于等于`1.13`。

```
# *******************************************************************************
# https://github.com/microsoft/vscode-go/blob/master/src/goTools.ts
# *******************************************************************************
# {
# 	'gocode': {
# 		name: 'gocode',
# 		importPath: 'github.com/mdempsky/gocode',
# 		isImportant: true,
# 		description: 'Auto-completion, does not work with modules',
# 	},
# 	'gocode-gomod': {
# 		name: 'gocode-gomod',
# 		importPath: 'github.com/stamblerre/gocode',
# 		isImportant: true,
# 		description: 'Auto-completion, works with modules',
# 	},
# 	'gopkgs': {
# 		name: 'gopkgs',
# 		importPath: 'github.com/uudashr/gopkgs/cmd/gopkgs',
# 		isImportant: true,
# 		description: 'Auto-completion of unimported packages & Add Import feature',
# 	},
# 	'go-outline': {
# 		name: 'go-outline',
# 		importPath: 'github.com/ramya-rao-a/go-outline',
# 		isImportant: true,
# 		description: 'Go to symbol in file',
# 	},
# 	'go-symbols': {
# 		name: 'go-symbols',
# 		importPath: 'github.com/acroca/go-symbols',
# 		isImportant: false,
# 		description: 'Go to symbol in workspace',
# 	},
# 	'guru': {
# 		name: 'guru',
# 		importPath: 'golang.org/x/tools/cmd/guru',
# 		isImportant: false,
# 		description: 'Find all references and Go to implementation of symbols',
# 	},
# 	'gorename': {
# 		name: 'gorename',
# 		importPath: 'golang.org/x/tools/cmd/gorename',
# 		isImportant: false,
# 		description: 'Rename symbols',
# 	},
# 	'gomodifytags': {
# 		name: 'gomodifytags',
# 		importPath: 'github.com/fatih/gomodifytags',
# 		isImportant: false,
# 		description: 'Modify tags on structs',
# 	},
# 	'goplay': {
# 		name: 'goplay',
# 		importPath: 'github.com/haya14busa/goplay/cmd/goplay',
# 		isImportant: false,
# 		description: 'The Go playground',
# 	},
# 	'impl': {
# 		name: 'impl',
# 		importPath: 'github.com/josharian/impl',
# 		isImportant: false,
# 		description: 'Stubs for interfaces',
# 	},
# 	'gotype-live': {
# 		name: 'gotype-live',
# 		importPath: 'github.com/tylerb/gotype-live',
# 		isImportant: false,
# 		description: 'Show errors as you type',
# 	},
# 	'godef': {
# 		name: 'godef',
# 		importPath: 'github.com/rogpeppe/godef',
# 		isImportant: true,
# 		description: 'Go to definition',
# 	},
# 	'gogetdoc': {
# 		name: 'gogetdoc',
# 		importPath: 'github.com/zmb3/gogetdoc',
# 		isImportant: true,
# 		description: 'Go to definition & text shown on hover',
# 	},
# 	'goimports': {
# 		name: 'goimports',
# 		importPath: 'golang.org/x/tools/cmd/goimports',
# 		isImportant: true,
# 		description: 'Formatter',
# 	},
# 	'goreturns': {
# 		name: 'goreturns',
# 		importPath: 'github.com/sqs/goreturns',
# 		isImportant: true,
# 		description: 'Formatter',
# 	},
# 	'goformat': {
# 		name: 'goformat',
# 		importPath: 'winterdrache.de/goformat/goformat',
# 		isImportant: false,
# 		description: 'Formatter',
# 	},
# 	'golint': {
# 		name: 'golint',
# 		importPath: 'golang.org/x/lint/golint',
# 		isImportant: true,
# 		description: 'Linter',
# 	},
# 	'gotests': {
# 		name: 'gotests',
# 		importPath: 'github.com/cweill/gotests/...',
# 		isImportant: false,
# 		description: 'Generate unit tests',
# 	},
# 	'staticcheck': {
# 		name: 'staticcheck',
# 		importPath: 'honnef.co/go/tools/...',
# 		isImportant: true,
# 		description: 'Linter',
# 	},
# 	'golangci-lint': {
# 		name: 'golangci-lint',
# 		importPath: 'github.com/golangci/golangci-lint/cmd/golangci-lint',
# 		isImportant: true,
# 		description: 'Linter',
# 	},
# 	'revive': {
# 		name: 'revive',
# 		importPath: 'github.com/mgechev/revive',
# 		isImportant: true,
# 		description: 'Linter',
# 	},
# 	'go-langserver': {
# 		name: 'go-langserver',
# 		importPath: 'github.com/sourcegraph/go-langserver',
# 		isImportant: false,
# 		description: 'Language Server from Sourcegraph',
# 	},
# 	'gopls': {
# 		name: 'gopls',
# 		importPath: 'golang.org/x/tools/gopls',
# 		isImportant: false,
# 		description: 'Language Server from Google',
# 	},
# 	'dlv': {
# 		name: 'dlv',
# 		importPath: 'github.com/go-delve/delve/cmd/dlv',
# 		isImportant: false,
# 		description: 'Debugging',
# 	},
# 	'fillstruct': {
# 		name: 'fillstruct',
# 		importPath: 'github.com/davidrjenni/reftools/cmd/fillstruct',
# 		isImportant: false,
# 		description: 'Fill structs with defaults',
# 	},
# 	'godoctor': {
# 		name: 'godoctor',
# 		importPath: 'github.com/godoctor/godoctor',
# 		isImportant: false,
# 		description: 'Extract to functions and variables',
# 	},
# }
# *******************************************************************************
```