# Individual Summative Lab

## Task 1

The first task dealt with setting up the project and it's file structure and include all necessary files.

### I used these steps to set up the project

1. I created a script `create_environment.sh`
2. When the user runs it, it prompts them to enter their names.
3. Then it will create a directory `submission_reminder_{user_name}` and replace `user_name` with the actual name a user used.
4. Then by using `mkdir` commands, it creates the following folder following this tree structure

```
submission_reminder_{user_name}
├─ app
│  └─ reminder.sh
├─ modules
│  └─ functions.sh
├─ assets
│  └─ submissions.tx
├─ config
│  └─ config.env
└─ startup.sh
```

5. I used `cat` command to create all the files we needed; `reminder.sh`, `functions.sh`, `submissions.txt`, `config.env` and `startup.sh` files.
6. In the middle of the script, I add a lot of `echo` statements to update the user on each step, what's going on.
7. After, I made sure that the script runs the `chmod +x` command to give all `*.sh` files executable permissions.
