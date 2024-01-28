#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Welcomes the user prompted for new and old players
WELCOME() {
    echo "Enter your username:"
    read USERNAME

    # Try to get user
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
    
    # If user doesn't exist
    if [[ -z $USER_ID ]]
    then 
        # Create User
        INSERT_USER=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
    
        # If success
        if [[ $INSERT_USER == 'INSERT 0 1' ]]
        then 
            # Get the user_id, this can be use later on
            USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")
        else
            # If failed
            echo "Failed to create user"
            return
        fi

        # Greet the new user
        echo "Welcome, $USERNAME! It looks like this is your first time here."
    
    # If user already exists
    else
        # Get the user game data (games_played)
        GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games LEFT JOIN users USING(user_id) WHERE name='$USERNAME'")

        # Get the user game data (best_game)
        BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games LEFT JOIN users USING(user_id) WHERE name='$USERNAME'")

        # If the user hasn't already played yet (best_game = null)
        if [[ -z $BEST_GAME ]]
        then
            # Assign 0 to it
            BEST_GAME=0;
        fi

        # Greet the user
        echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    fi

    # Start the game
    GAME "Guess the secret number between 1 and 1000:"
}

# Generates a guessing number from 1 to 1000
GENERATE_NUMBER() {
    echo "Generate Number" 
}

# Initial Guessing Game
GAME() {
    echo "Guessing Game"
}

# Outputs the results of the game after the user guessed the number
GUESSED() {
    echo "Guessed"
}

# START 
WELCOME 

