function _nvim_diffview -a subcommand
    set args $argv[2..]

    switch $subcommand
        case file
            _diff_file $args
        case commit_file
            _diff_commit_file $args
        case commits
            _diff_commits $args
        case local_branch
            _diff_local_branch $args
        case remote_branch
            _diff_remote_branch $args
        case stash_entry
            _diff_stash_entry $args
    end
end

function _nvim_remote_cmd -a ex_cmd
    if test -n "$NVIM"
        nvim --server "$NVIM" --remote-send "<C-\><C-n>:$ex_cmd<Cr>"
    end
end

function _diff_file -a path
    _nvim_remote_cmd "DiffviewOpen --selected-file=$path --imply-local"
end

function _diff_commit_file -a commit path
    _nvim_remote_cmd "DiffviewOpen $commit^..$commit --selected-file=$path"
end

function _diff_commits -a commit_from commit_to
    set range $commit_from^..$commit_to
    set range_count $(git rev-list --count $range)

    if test "$range_count" -le 1
        set cmd "DiffviewOpen $range"
    else
        set cmd "DiffviewFileHistory --range=$range"
    end

    _nvim_remote_cmd $cmd
end

function _diff_stash_entry -a entry_idx
    set ref_name "stash@{$entry_idx}"

    _nvim_remote_cmd "DiffviewOpen $ref_name^..$ref_name"
end

function _diff_local_branch -a branch
    _nvim_remote_cmd "DiffviewOpen --imply-local ...$branch"
end

function _diff_remote_branch -a remote branch
    set range "$remote/HEAD...$remote/$branch"
    set range_count $(git rev-list --count $range --right-only --no-merges)

    if test "$range_count" -le 1
        set cmd "DiffviewOpen $range"
    else
        set cmd "DiffviewFileHistory --range=$range --right-only --no-merges"
    end

    _nvim_remote_cmd $cmd
end
