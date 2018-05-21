function __fish_using_command
    set cmd (commandline -opc)
    if [ (count $cmd) -eq (count $argv) ]
        for i in (seq (count $argv))
            if [ $cmd[$i] != $argv[$i] ]
                return 1
            end
        end
        return 0
    end
    return 1
end

complete -c fd -n "__fish_using_command fd" -s d -l max-depth -d 'Set maximum search depth (default: none)'
complete -c fd -n "__fish_using_command fd" -s t -l type -d 'Filter by type: file (f), directory (d), symlink (l),
executable (x)' -r -f -a "f file d directory l symlink x executable"
complete -c fd -n "__fish_using_command fd" -s e -l extension -d 'Filter by file extension'
complete -c fd -n "__fish_using_command fd" -s x -l exec -d 'Execute a command for each search result'
complete -c fd -n "__fish_using_command fd" -s E -l exclude -d 'Exclude entries that match the given glob pattern'
complete -c fd -n "__fish_using_command fd" -l ignore-file -d 'Add a custom ignore-file in .gitignore format'
complete -c fd -n "__fish_using_command fd" -s c -l color -d 'When to use colors: never, *auto*, always' -r -f -a "never auto always"
complete -c fd -n "__fish_using_command fd" -s j -l threads -d 'Set number of threads to use for searching & executing'
complete -c fd -n "__fish_using_command fd" -l max-buffer-time -d 'the time (in ms) to buffer, before streaming to the console'
complete -c fd -n "__fish_using_command fd" -s H -l hidden -d 'Search hidden files and directories'
complete -c fd -n "__fish_using_command fd" -s I -l no-ignore -d 'Do not respect .(git|fd)ignore files'
complete -c fd -n "__fish_using_command fd" -l no-ignore-vcs -d 'Do not respect .gitignore files'
complete -c fd -n "__fish_using_command fd" -s u -d 'Alias for no-ignore and/or hidden'
complete -c fd -n "__fish_using_command fd" -s s -l case-sensitive -d 'Case-sensitive search (default: smart case)'
complete -c fd -n "__fish_using_command fd" -s i -l ignore-case -d 'Case-insensitive search (default: smart case)'
complete -c fd -n "__fish_using_command fd" -s F -l fixed-strings -d 'Treat the pattern as a literal string'
complete -c fd -n "__fish_using_command fd" -s a -l absolute-path -d 'Show absolute instead of relative paths'
complete -c fd -n "__fish_using_command fd" -s L -l follow -d 'Follow symbolic links'
complete -c fd -n "__fish_using_command fd" -s p -l full-path -d 'Search full path (default: file-/dirname only)'
complete -c fd -n "__fish_using_command fd" -s 0 -l print0 -d 'Separate results by the null character'
complete -c fd -n "__fish_using_command fd" -s h -l help -d 'Prints help information'
complete -c fd -n "__fish_using_command fd" -s V -l version -d 'Prints version information'
