function _lazygit -a subcommand
    set args $argv[2..]

    switch $subcommand
        case nvim_term_close
            nvim_term_close $args
        case edit_file
            edit_file $args
        case edit_file_at_line
            edit_file_at_line $args
    end
end

function nvim_remote_send -a keys
    nvim --server "$NVIM" --remote-send $keys
end

function nvim_remote_file -a path
    nvim --server "$NVIM" --remote $path
end

function nvim_term_close
    nvim_remote_send "<C-\><C-n><Cmd>close<Cr>"
end

function edit_file -a path
    if test -n "$NVIM"
        nvim_term_close
        nvim_remote_file $path
    else
        nvim -- $path
    end
end

function edit_file_at_line -a path line
    if test -n "$NVIM"
        nvim_term_close
        nvim_remote_file $path
        nvim_remote_send "<Cmd>$line<CR>"
    else
        nvim +$line -- $path
    end
end
