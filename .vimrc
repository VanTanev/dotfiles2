" vim:set ts=2 sts=2 sw=2 expandtab:

" remove all existing autocmds
autocmd!

" polygot disables need to be before infect
" let g:polyglot_disabled = ['javascript', 'jsx']
" let g:ale_completion_enabled = 1

" let g:ale_fixers = {
"       \   'javascript': ['eslint'],
"       \   'typescript': ['prettier'],
"       \   'php': ['php_cs_fixer'],
"       \}
" let g:ale_javascript_eslint_suppress_eslintignore = 1

execute pathogen#infect()
syntax on
filetype plugin indent on

" plugin settings
" let g:javascript_plugin_jsdoc = 1
" let g:javascript_plugin_ngdoc = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set laststatus=2
set showmatch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=2
set switchbuf=useopen
set showtabline=2
set winwidth=79

" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=

" keep more context when scrolling off the end of a buffer
set scrolloff=3

" Don't make backups at all
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" display incomplete commands
set showcmd

" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list

" make tab completion for files/buffers act like bash
let mapleader=","
" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

" Setting some decent VIM settings for programming
set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set nocompatible                " vi compatible is LAME
set showmode                    " show the current mode
set background=light            " Use light background for solarized
let g:solarized_termcolors=256
colorscheme solarized

"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    "Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && expand("%") !~ "COMMIT_EDITMSG"
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff"
      \           && expand("%") !~ "git-rebase-todo" |
      \   exe "normal g`\"" |
      \ endif
endif " has("autocmd")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " for perl, do not expand tabs
  autocmd FileType perl set ai sw=4 sts=0 noexpandtab

  " for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,sass,cucumber set ai sw=2 sts=2 et
  " for js,python,php, 4 spaces
  autocmd FileType js,javascript,html,python,php set ai sw=4 sts=4 et

  " for make files, never expand tabs
  autocmd FileType make setlocal noexpandtab

  autocmd! BufRead,BufNewFile *.sass set filetype=sass
  autocmd! BufRead,BufNewFile *.scss set filetype=sass
  autocmd! BufRead,BufNewFile *.tsx  set filetype=typescript.tsx

  autocmd BufRead *.md set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.mkd set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:&gt;

  " Treat ngdoc (Angular Doc) as markdown. It's close enough.
  autocmd BufRead *.ngdoc set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd! BufRead,BufNewFile *.ngdoc set filetype=markdown

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  autocmd FileType php call PhpSyntaxOverride()
  function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
    hi! def link phpDocIdentifier phpIdentifier
  endfunction

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HELPER MAPPINGS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>
" Close all other windows, open a vertical split, and open this file's test
" alternate in it.
nnoremap <leader>s :call FocusOnFile()<cr>
function! FocusOnFile()
  tabnew %
  normalv
  normall
  call OpenTestAlternate()
  normalh
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPEN FILES IN DIRECTORY OF CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'
map <leader>e :edit %%
map <leader>v :view %%

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let is_js = match(current_file, '\.js$') != -1
  let is_ts = match(current_file, '\.tsx\?$') != -1
  let is_php = match(current_file, '\.php$') != -1
  let is_rb = match(current_file, '\.e\?rb$') != -1

  let in_test_file = match(current_file, '^spec/') != -1 || match(current_file, '\.spec\.js$') != -1 || match(current_file, 'Test\.php$') != -1 || match(current_file, '__tests__') != -1
  let in_app_subdir = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1 || match(current_file, '\<service\>') != -1 || match(current_file, '<\extensions\>') != 1

  let alt_file = current_file
  if is_js
    if in_test_file
      let alt_file = substitute(alt_file, '\.spec\.js$', '.js', '')
    else
      let alt_file = substitute(alt_file, '\.js$', '.spec.js', '')
    endif
  elseif is_ts
    if in_test_file
      let alt_file = substitute(alt_file, '__tests__/', '', '')
    else
      let basename = expand('%:t:r') . '.' . expand('%:e')
      let alt_file = substitute(alt_file, basename, '__tests__/' . basename, '')
    endif
  elseif is_php
    if in_test_file
      let alt_file = substitute(alt_file, 'tests/', '', '')
      if in_app_subdir
        let alt_file = 'app/' . alt_file
      endif
      let alt_file = substitute(alt_file, 'Test\.php$', '.php', '')
    else
      if in_app_subdir
        let alt_file = substitute(alt_file, 'app/', '', '')
      endif
      let alt_file = 'tests/' . alt_file
      let alt_file = substitute(alt_file, '\.php$', 'Test\.php', '')
    endif
  elseif is_rb
    if in_test_file
      let alt_file = substitute(alt_file, 'spec/', '', '')
      if in_app_subdir
        let alt_file = 'app/' . alt_file
      endif
      let alt_file = substitute(alt_file, '_spec\.rb$', '.rb', '')
    else
      if in_app
        let alt_file = substitute(alt_file, 'app/', '', '')
      endif
      let alt_file = substitute(alt_file, '\.e\?rb$', '_spec.rb', '')
      let alt_file = 'spec/' . alt_file
    endif
  endif

  return alt_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :call RunTestFile()<cr>
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

" Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(_spec.rb\|_test.rb\|test_.*\.py\|_test.py\|.test.ts\|__tests__.*\.tsx\=\)$') != -1
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    " The file is executable; assume we should run
    if executable(a:filename)
      exec ":!./" . a:filename
    " Project-specific test script
    elseif filereadable("bin/test")
      exec ":!bin/test " . a:filename
    " Rspec binstub
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec " . a:filename
    " Fall back to a blocking test run with Bundler
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("spec/**/*.rb"))
      exec ":!bundle exec rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("test/**/*.rb"))
      exec ":!bin/rails test " . a:filename
    " If we see python-looking tests, assume they should be run with Nose
    elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
      exec "!nosetests " . a:filename
    end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

" Show trailing whitespaces (among other things, see :h listchars)
set list
" A eol whitespace cleaner command
function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

" Edit the newest file in a target directory
function! EditLatestInDir(dir)
  let file = system('echo ' . a:dir . '/$(ls -rt ' . a:dir . ' |tail -1)')
  exec "edit " . file
endfunction
command! -nargs=1 -complete=dir Latest :call EditLatestInDir(<f-args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
    " Escape spaces in the file name. That ensures that it's a single argument
    " when concatenated with vim_command and run with exec.
    let selection = substitute(selection, ' ', '\\ ', "g")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

function! SelectaFile(path, glob)
  let gitignore_file = '.gitignore'

  let ignore_dirs = ['node_modules', 'bower_components', 'tmp']
  let ignore_extensions = ['pyc', 'jpg', 'png', 'ttf', 'woff', 'woff2', 'eot', 'svg']
  let ignore_files = []
  for ext in ignore_extensions
    call add(ignore_files, "'*." . ext . "'")
  endfor

  if filereadable(gitignore_file)
      for oline in readfile(gitignore_file)
          let line = substitute(oline, '\s|\n|\r', '', "g")

          " skip empty lines
          if line == '' | con  | endif

          " skip negated gitignores
          if line =~ '^#' | con | endif
          if line =~ '^!' | con  | endif

          " in .gitignore, we may ignore dirs with "/dir" or "dir/", but
          " in find -prune we need to convert that to "dir"
          if line =~ '^/\w\+$' || line =~ '/$'
            call add(ignore_dirs, substitute(line, '^/\|/$', '', 'g'))
          else
            " if we don't match the above format, assume file
            call add(ignore_files, line)
          endif
      endfor
  endif

  let prune_dirs = ''
  for dirname in ignore_dirs
    let prune_dirs .= ' -type d -name ' . dirname . ' -prune -o'
  endfor

  let ignore_glob = ''
  for filename in ignore_files
    let ignore_glob .= ' ! -iname ' . filename
  endfor

  call SelectaCommand("find " . a:path . "/* " . prune_dirs . " -type f -and -iname '" . a:glob . "' " . ignore_glob . " -print 2>/dev/null", "", ":e")
endfunction

nnoremap <leader>f :call SelectaFile(".", "*")<cr>

"Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>


""""""""""""""""""""""
" COC suggested setup
""""""""""""""""""""""


" if hidden is not set, TextEdit might fail.
set hidden

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
" set cmdheight=2

" don't give |ins-completion-menu| messages.
" set shortmess+=c

" always show signcolumns
" set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" " Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)

" " Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" " Remap for format selected region
" " xmap <leader>f  <Plug>(coc-format-selected)
" " nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)

" " Use <tab> for select selections ranges, needs server support, like:
" " coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" " Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
