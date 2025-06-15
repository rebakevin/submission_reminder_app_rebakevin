#!/bin/bash

# Prompt user for their name
echo "Enter your name:"
read user_name

# Create main project directory
project_dir="submission_reminder_${user_name}1"
echo "Creating project directory: $project_dir"
mkdir -p "$project_dir"

# Create subdirectories
mkdir -p "$project_dir/app"
mkdir -p "$project_dir/modules"
mkdir -p "$project_dir/assets"
mkdir -p "$project_dir/config"

# Create reminder.sh in app directory
cat > "$project_dir/app/reminder.sh" << 'EOF'
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

# Create functions.sh in modules directory
cat > "$project_dir/modules/functions.sh" << 'EOF'
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

# Create submissions.txt in assets directory
cat > "$project_dir/assets/submissions.txt" << 'EOF'
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

# Create config.env in config directory
cat > "$project_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create startup.sh in root directory
cat > "$project_dir/startup.sh" << 'EOF'
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

# Make all .sh files executable in the project directory
echo "Setting executable permissions for all .sh files..."
find "$project_dir" -name "*.sh" -type f -exec chmod +x {} \;

echo "Project setup complete!"
echo "Project structure created in: $project_dir"
echo ""
echo "To run the project:"
echo "cd $project_dir"
echo "./startup.sh"