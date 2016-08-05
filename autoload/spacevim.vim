function! spacevim#bootstrap() abort
  " vim-plug automatic installation {{{
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd vimrc VimEnter * PlugInstall | source $MYVIMRC
  endif
  " }}}

  let l:spacevim_layers = {
        \  'core': [
        \    'dbakker/vim-projectroot',
        \    'easymotion/vim-easymotion',
        \    'haya14busa/incsearch.vim',
        \    'hecal3/vim-leader-guide',
        \    'junegunn/fzf',
        \    'junegunn/fzf.vim',
        \    'junegunn/gv.vim',
        \    'mbbill/undotree',
        \    'osyo-manga/vim-over',
        \    'Raimondi/delimitMate',
        \    'scrooloose/syntastic',
        \    'sheerun/vim-polyglot',
        \    'tpope/vim-commentary',
        \    'tpope/vim-eunuch',
        \    'tpope/vim-surround',
        \    'tpope/vim-sensible',
        \    'tpope/vim-vinegar'
        \  ],
        \  'git': [
        \    'airblade/vim-gitgutter',
        \    'tpope/vim-fugitive'
        \  ]
        \  }

  call plug#begin('~/.vim/plugged')
  for layer in g:dotspacevim_configuration_layers
    let l:plugins = get(l:spacevim_layers, layer, [])
    for plugin in plugins
      Plug plugin
    endfor
  endfor
  Plug 'ctjhoa/spacevim'
  call plug#end()
endfunction
"
