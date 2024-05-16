#!/bin/bash

# Function to get the nested value from a JSON object
# Arguments:
#   $1 - JSON object
#   $2 - Key path (e.g., "a/b/c")

get_nested_value() {
    echo "$1" | jq -r --argjson keys "[$2 | split(\"/\")[]]" 'getpath($keys)'
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
