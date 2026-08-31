function _nvim_diffview -a subcommand
    if test -z "$NVIM"
        return
    end

    set args $argv[2..]

    switch $subcommand
        case file
            diff_file $args
        case commit_file
            diff_commit_file $args
        case commits
            diff_commits $args
        case local_branch
            diff_local_branch $args
        case remote_branch
            diff_remote_branch $args
        case stash_entry
            diff_stash_entry $args
    end
end

function remote_term_cmd -a ex_cmd
    nvim --server "$NVIM" --remote-send "<C-\><C-n><Cmd>$ex_cmd<Cr>"
end

function diff_file -a path
    remote_term_cmd "DiffviewOpen --selected-file=$path --imply-local"
end

function diff_commit_file -a commit path
    remote_term_cmd "DiffviewOpen $commit^..$commit --selected-file=$path"
end

function diff_commits -a commit_from commit_to
    set range $commit_from^..$commit_to
    set range_count $(git rev-list --count $range)

    if test "$range_count" -le 1
        set cmd "DiffviewOpen $range"
    else
        set cmd "DiffviewFileHistory --range=$range"
    end

    remote_term_cmd $cmd
end

function diff_stash_entry -a entry_idx
    set ref_name "stash@{$entry_idx}"

    remote_term_cmd "DiffviewOpen $ref_name^..$ref_name"
end

function diff_local_branch -a branch
    remote_term_cmd "DiffviewOpen --imply-local ...$branch"
end

function diff_remote_branch -a remote branch
    set range "$remote/HEAD...$remote/$branch"
    set range_count $(git rev-list --count $range --right-only --no-merges)

    if test "$range_count" -le 1
        set cmd "DiffviewOpen $range"
    else
        set cmd "DiffviewFileHistory --range=$range --right-only --no-merges"
    end

    remote_term_cmd $cmd
end
