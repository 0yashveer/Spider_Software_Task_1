#!/bin/bash

# A dummy bash file with functions, loops, and conditions

# Function to greet someone
greet() {
    echo "Hello $1, welcome to Bash scripting!"
}

# Function to add two numbers
add_numbers() {
    sum=$(( $1 + $2 ))
    echo "The sum of $1 and $2 is: $sum"
}

# Function to check if a number is less than or equal to 5
check_number() {
    if [ $1 -le 5 ]; then
        echo "$1 is less than or equal to 5"
    else
        echo "$1 is greater than 5"
    fi
}

# Main script execution
echo "=== Dummy Bash Script ==="

# Call greet function
greet "Yashveer"

# Call add_numbers function
add_numbers 3 7

# Call check_number function
check_number 4
check_number 9

# Loop through arguments
echo "Looping through arguments:"
for arg in "$@"; do
    echo "Argument: $arg"
done

echo "=== End of Script ==="
