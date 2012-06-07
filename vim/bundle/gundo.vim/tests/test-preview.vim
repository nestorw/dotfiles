UTSuite [Gundo] Testing Preview Pane

function! s:Setup()"{{{
    exec 'edit test'
    call g:Goto('test')
endfunction"}}}
function! s:Teardown()"{{{
    if bufwinnr(bufnr('__Gundo__')) != -1
        exec bufwinnr(bufnr('__Gundo__')) . 'wincmd w'
        quit
    endif
    if bufwinnr(bufnr('__Gundo_Preview__')) != -1
        exec bufwinnr(bufnr('__Gundo_Preview__')) . 'wincmd w'
        quit
    endif
    if bufnr('__Gundo__') != -1
        exec 'bwipeout! ' . bufnr('__Gundo__')
    endif
    if bufnr('__Gundo_Preview__') != -1
        exec 'bwipeout! ' . bufnr('__Gundo_Preview__')
    endif
    if bufnr('test') != -1
        exec 'bwipeout! ' . bufnr('test')
    endif
    if bufnr('test2') != -1
        exec 'bwipeout! ' . bufnr('test2')
    endif
endfunction"}}}

function! s:TestPreviewBasic()"{{{
    " Make three linear changes, then a change that deletes the last line
    call g:TypeLineDone("ONE")
    call g:TypeLineDone("TWO")
    call g:TypeLineDone("THREE")
    normal k
    normal dd

    " Open Gundo
    GundoToggle

    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("THREE")
    Assert g:CurrentLineContains("-THREE")

    call g:Goto("__Gundo__")
    normal j
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("THREE")
    Assert g:CurrentLineContains("+THREE")

    call g:Goto("__Gundo__")
    normal j
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("TWO")
    Assert g:CurrentLineContains("+TWO")

    call g:Goto("__Gundo__")
    normal j
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("ONE")
    Assert g:CurrentLineContains("+ONE")

    call g:Goto("__Gundo__")
    normal k
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("TWO")
    Assert g:CurrentLineContains("+TWO")

    call g:Goto("__Gundo__")
    normal k
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("THREE")
    Assert g:CurrentLineContains("+THREE")

    call g:Goto("__Gundo__")
    normal k
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("THREE")
    Assert g:CurrentLineContains("-THREE")
endfunction"}}}

function! s:TestPreviewLinear()"{{{
    " Make four non-linear changes
    "
    " o   [4]
    " |
    " | o [3]
    " | |
    " o | [2]
    " |/
    " o   [1]

    call g:TypeLineDone("ONE")
    call g:TypeLineDone("TWO")
    silent! undo
    call g:TypeLineDone("THREE")
    silent! undo 2
    call g:TypeLineDone("FOUR")

    " Open Gundo
    GundoToggle

    " Check state 4
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("FOUR")
    Assert g:CurrentLineContains("+FOUR")
    call g:GotoLineContaining("THREE")
    Assert !g:CurrentLineContains("THREE")

    " Check state 3
    call g:Goto("__Gundo__")
    normal j
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("THREE")
    Assert g:CurrentLineContains("+THREE")
    call g:GotoLineContaining("FOUR")
    Assert !g:CurrentLineContains("FOUR")
    call g:GotoLineContaining("TWO")
    Assert !g:CurrentLineContains("TWO")
    call g:GotoLineContaining("ONE")
    Assert g:CurrentLineContains("ONE")

    " Check state 2
    call g:Goto("__Gundo__")
    normal j
    call g:Goto("__Gundo_Preview__")
    call g:GotoLineContaining("TWO")
    Assert g:CurrentLineContains("+TWO")
    call g:GotoLineContaining("ONE")
    Assert g:CurrentLineContains("ONE")
endfunction"}}}
