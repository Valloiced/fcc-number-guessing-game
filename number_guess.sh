#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# Welcomes the user prompted for new and old players
WELCOME() {
    echo "Welcome"
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

