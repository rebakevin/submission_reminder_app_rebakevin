#!/bin/bash

# Prompt user for their name
echo "Enter your name:"
read names

# Create main project directory
project_directory="submission_reminder_${names}"
echo "Creating project directory: $project_directory"
mkdir -p "$project_directory"

# Create subdirectories
mkdir -p "$project_directory/app"
mkdir -p "$project_directory/modules"
mkdir -p "$project_directory/assets"
mkdir -p "$project_directory/config"

# reminder.sh
cat > "$project_directory/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# functions.sh
cat > "$project_directory/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# submissions.txt
cat > "$project_directory/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Kevin, Git, submitted
Victor, Git, submitted
Ellie, Shell Navigation, not submitted
Pacy, Shell Navigation, submitted
Igor, Git, not submitted
EOF

# config.env
cat > "$project_directory/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create startup.sh in root directory
cat > "$project_directory/startup.sh" << 'EOF'
#!/bin/bash

echo "Starting Submission Reminder Application..."
echo "==========================================="

# Check if required files exist
if [ ! -f "./config/config.env" ]; then
    echo "Error: Configuration file not found!"
    exit 1
fi

if [ ! -f "./modules/functions.sh" ]; then
    echo "Error: Functions file not found!"
    exit 1
fi

if [ ! -f "./app/reminder.sh" ]; then
    echo "Error: Reminder script not found!"
    exit 1
fi

# Navigate to the app directory and run the reminder script
echo "Launching reminder application..."
echo ""
cd app
./reminder.sh

echo ""
echo "Application finished."
EOF

# making all files executable
echo "Setting executable permissions for all .sh files..."
find "$project_directory" -name "*.sh" -type f -exec chmod +x {} \;

echo "Project setup complete!"
echo ""
echo "To run the project:"
echo "./startup.sh"