#!/bin/bash

# Script to update assignment name in config/config.env and rerun startup.sh

echo "Assignment Update Script"
echo "======================="

# Check if config file exists
if [ ! -f "./submission_reminder_kevin/config/config.env" ]; then
    echo "Error: submission_reminder_kevin/config/config.env file not found!"
    exit 1
fi

# Display current assignment
current_assignment=$(grep "^ASSIGNMENT=" ./submission_reminder_kevin/config/config.env | cut -d'"' -f2)
echo "Current assignment: $current_assignment"
echo ""

# Prompt user for new assignment name
echo "Enter the new assignment name:"
read new_assignment

# Validate input
if [ -z "$new_assignment" ]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

echo ""
echo "Updating assignment from '$current_assignment' to '$new_assignment'..."

# Replace ASSIGNMENT value in config.env using sed
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" ./submission_reminder_kevin/config/config.env

# Check if sed command was successful
if [ $? -eq 0 ]; then
    echo "Assignment updated successfully!"
    echo ""
    
    # Display updated config
    echo "Updated configuration:"
    cat ./submission_reminder_kevin/config/config.env
    echo ""
    
    # Rerun startup.sh
    echo "Restarting application with new assignment..."
    echo "============================================="
    cd submission_reminder_kevin
    ./startup.sh
else
    echo "Error: Failed to update assignment in config file!"
    exit 1
fi