function! spacevim#bootstrap() abort
  " Set up path variables {{{
  let config_dir = $HOME . '/.config/nvim'
  let vim_plug = expand(resolve(config_dir . '/autoload/plug.vim'))
  let vim_plugged = expand(resolve(config_dir . '/plugged'))
  let spacevim_layers_dir = expand(resolve(config_dir . '/spaceneovim-layers'))
  " }}}

  " Download the layers {{{
  if empty(glob(spacevim_layers_dir))
    let install_layers = jobstart([
    \  'git'
    \, 'clone'
    \, 'git@github.com:Tehnix/spaceneovim-layers.git'
    \, spacevim_layers_dir
    \])
    let waiting_for_layers = jobwait([install_layers])
  endif
  " }}}

  " Add the layers to g:spacevim_layers {{{
  let g:spacevim_layers = []

  if filereadable(spacevim_layers_dir . '/layers.vim')
    execute 'source ' . spacevim_layers_dir . '/layers.vim'
  endif
  " }}}

  " Add all valid layers to enabled layers {{{
  let g:spacevim_enabled_layers = []

  if exists('g:dotspacevim_configuration_layers')
    for configuration_layer in g:dotspacevim_configuration_layers
      for layer in g:spacevim_layers
        if layer =~ configuration_layer
          call add(g:spacevim_enabled_layers, layer)
        endif
      endfor
    endfor
  endif
  " }}}

  " Setup and install vim-plug {{{
  if empty(glob(vim_plug))
    let install_plug = jobstart([
    \  'curl'
    \, '-fLo'
    \, vim_plug
    \, '--create-dirs'
    \, 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    \])
    let waiting_for_plug = jobwait([install_plug])
    let install_plug_packages = jobstart(['nvim', '+PlugInstall', '+qall'])
    let waiting_for_packages = jobwait([install_plug_packages])
    source $MYVIMRC
  endif
  " }}}

  " Install all plugins from enabled layers {{{
  call plug#begin(vim_plugged)
  Plug 'hecal3/vim-leader-guide'
  let g:spacevim_plugins = []
  for layer in g:spacevim_enabled_layers
    execute 'source ' . spacevim_layers_dir . '/layers/' . layer . '/packages.vim'
    execute 'source ' . spacevim_layers_dir . '/layers/' . layer . '/config.vim'
  endfor

  for plugin in g:spacevim_plugins
    Plug plugin.name, plugin.config
  endfor

  if exists('g:dotspacevim_additional_plugins')
    for additional_plugin in g:dotspacevim_additional_plugins
      Plug additional_plugin
    endfor
  endif
  call plug#end()
  " }}}

endfunction
