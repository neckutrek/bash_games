echo "including utils.sh"

dec_to_char() {
    printf '%b' '\'$(printf '%o' $1)
}

repeat() {
    for (( i=0; i<$1; i++)); do echo -n "$2"; done
}

putc() {
    local -n arr=$4
    line="${arr[$2]}"
    echo "$line"
    line="$(echo -n "$line" | sed 's/./'$3'/'$1)"
    echo "$line"
    arr[$2]="$line"
}
