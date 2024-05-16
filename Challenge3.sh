#!/bin/bash

get_nested_value() {
    local obj="$1"
    local key="$2"
    local IFS='/'
    local keys=($key)
    local current_obj="$obj"

    for k in "${keys[@]}"; do
        current_obj=$(echo "$current_obj" | jq -r --arg k "$k" '.[$k]')
        if [ "$current_obj" == "null" ]; then
            echo "null"
            return
        fi
    done

    echo "$current_obj"
}

# Example usage:
obj1='{"a":{"b":{"c":"d"}}}'
key1="a/b/c"
result1=$(get_nested_value "$obj1" "$key1")
echo "Result 1: $result1"  # Output: d

obj2='{"x":{"y":{"z":"a"}}}'
key2="x/y/z"
result2=$(get_nested_value "$obj2" "$key2")
echo "Result 2: $result2"  # Output: a
