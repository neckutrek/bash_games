echo "including utils.sh"

dec_to_char() {
    printf '%b' '\'$(printf '%o' $1)
}

repeat() {
    for (( i=0; i<$1; i++)); do echo -n "$2"; done
}
