-- https://github.com/ludovicchabant/vim-gutentags

-- Use local tags file for now. Telescope isn't compatible with custom dirs
-- vim.g.gutentags_cache_dir = '~/.gutentags'

-- From https://www.reddit.com/r/vim/comments/d77t6j/guide_how_to_setup_ctags_with_gutentags_properly/
vim.g.gutentags_ctags_extra_args = {
  '--tag-relative=yes',
  '--fields=+ailmnS'
}
vim.g.gutentags_ctags_exclude = {
  '*.git', '*.svg', '*.hg',
  '*/tests/*',
  'build',
  'dist',
  '*sites/*/files/*',
  'bin',
  'node_modules',
  'bower_components',
  'cache',
  'compiled',
  'docs',
  'example',
  'bundle',
  'vendor',
  '*.md',
  '*-lock.json',
  '*.lock',
  '*bundle*.js',
  '*build*.js',
  '.*rc*',
  '*.json',
  '*.min.*',
  '*.map',
  '*.bak',
  '*.zip',
  '*.pyc',
  '*.class',
  '*.sln',
  '*.Master',
  '*.csproj',
  '*.tmp',
  '*.csproj.user',
  '*.cache',
  '*.pdb',
  'tags*',
  'cscope.*',
  '*.css',
  '*.less',
  '*.scss',
  '*.exe', '*.dll',
  '*.mp3', '*.ogg', '*.flac',
  '*.swp', '*.swo',
  '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
  '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
  '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
}
