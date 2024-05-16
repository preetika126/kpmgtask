#!/bin/bash

get_nested_value() {
  echo "$1" | jq -r --argjson keys "$(echo '["'$(echo "$2" | sed 's|/|","|g')'"]')" 'getpath($keys)'
}

# Example usage
json1='{"a":{"b":{"c":"d"}}}'
key1="a/b/c"
value1=$(get_nested_value "$json1" "$key1")
echo "Result 1: $value1"  # Output: d

json2='{"x":{"y":{"z":"a"}}}'
key2="x/y/z"
value2=$(get_nested_value "$json2" "$key2")
echo "Result 2: $value2"  # Output: a
