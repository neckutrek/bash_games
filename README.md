Terminal games written in bash.

Snake

# Bash Expansions

## Double Quotes

    "

Preserves the literal meaning of the characters in the quote, except for

    $ ` \

## Command Substitution

Running multiple commands, capturing their output.

    $(echo "hej")
    `echo "hej"`

    echo $(< myfile.txt)
    echo $(cat myfile.txt)

## Process substitution

Running a command in a subshell

    ( echo "hej" )

## Parameter substitution

    X=10
    ${X}

