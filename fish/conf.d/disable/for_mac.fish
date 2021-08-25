if [ (uname -s) = "Darwin" ]
    alias rm='rmtrash'
    alias spbcopy='pbcopy ; pbpaste'

    function finder
        open .
    end
end
