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

    # Generate random number
    GENERATE_NUMBER 

    # Start the game
    GAME "Guess the secret number between 1 and 1000:"
}

# Generates a guessing number from 1 to 1000
GENERATE_NUMBER() {
    # Added one to avoid that 1/1000 chance of getting 0
    SECRET_NUMBER=$(( $RANDOM % 1000 + 1 )) 
}

# Initial Guessing Game

NUMBER_OF_GUESSES=1 # Used for the actual game

GAME() {
    # Message/Status
    if [[ $1 ]]
    then 
        echo $1
    fi

    read GUESS

    # If it's not an integer
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
        NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
        GAME "That is not an integer, guess again:"
        return
    
    # If it's lower than the random number
    elif [[ $GUESS -lt $SECRET_NUMBER ]]
    then
        NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
        GAME "It's higher than that, guess again:"
        return

    # If it's higher than the random number
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then
        NUMBER_OF_GUESSES=$(( $NUMBER_OF_GUESSES + 1 ))
        GAME "It's lower than that, guess again:"
        return
    else
        # If user guessed the number
        GUESSED 
    fi

}

# Outputs the results of the game after the user guessed the number and save it to the database
GUESSED() {
    # Output the result
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

    # Save game data
    SAVE_GAME_DATA=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)");

    if [[ $SAVE_GAME_DATA != 'INSERT 0 1' ]]
    then
        echo "Failed to save game data"
    fi

    exit
}

# START 
WELCOME 

