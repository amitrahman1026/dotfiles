# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# neovim alias
alias vim='nvim'

# VSCode fork
alias code='cursor'

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/amit/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# GITSTATUS_LOG_LEVEL=DEBUG

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"


# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
zsh-autosuggestions
poetry
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.8/bin
export PATH=~/.composer/vendor/bin:$PATH

export PATH="/usr/local/opt/binutils/bin:$PATH"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
export PATH="/usr/local/sbin:$PATH"
export PATH="/Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Ruby version management on m1
. "$HOME/.asdf/asdf.sh"
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.3.0

# GPG Signing
export GPG_TTY=$(tty)
export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.macos64_2.1.100.202311100844/tools/bin:$PATH"
export PATH="/Applications/STM32CubeIDE.app/Contents/Eclipse/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.macos64_2.1.100.202310302101/tools/bin:$PATH"

# Go binaries
export PATH="$HOME/go/bin:$PATH"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/amit/.opam/opam-init/init.zsh' ]] || source '/Users/amit/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# Python bs
export PATH="$HOME/Library/Python/3.12/bin:$PATH"

# LLVM clang & GCC path overrides -- note that on the mac
# you will have to pass in -isysroot (xcrun --show-sdk-path) as a flag
# because non Apple clang compilers are not aware of where the include files are!
# This is due to System Integrity Protections (SIP) supposedly locking /usr directory down
#
# Some solutions I see is making a symlink form apple's sdk headers to 
# /usr/include, however that isnt that seems to go against the principle of SIP
#
#
# export GCC_PATH=$(brew --prefix gcc)
# alias gcc='${GCC_PATH}/bin/gcc-14'
# alias g++='${GCC_PATH}/bin/g++-14'

#export LLVM_PATH=$(brew --prefix llvm)
# alias clang='${LLVM_PATH}/bin/clang'
# alias clang++='${LLVM_PATH}/bin/clang++'
# alias c++='${LLVM_PATH}/bin/clang++'
# alias clangd='${LLVM_PATH}/bin/clangd'

# Add LLVM Include paths before usr/bin
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# export CC="${LLVM_PATH}/bin/clang"
# export CXX="${LLVM_PATH}/bin/clang++"
# export CPPFLAGS="-I${LLVM_PATH}/include"
# export SDKROOT=$(xcrun --show-sdk-path)
# export LDFLAGS="-L${SDKROOT}/usr/lib"
alias conan2='/opt/homebrew/opt/conan/bin/conan'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/amit/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/amit/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/amit/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/amit/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
