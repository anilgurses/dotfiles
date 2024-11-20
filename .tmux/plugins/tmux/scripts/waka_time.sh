#!/usr/bin/env bash
# Setting the locale
export LC_ALL=en_US.UTF-8

# Function to display stats summary
display_stats() {
  wakatime-cli --today
}

# Main function
main() {
  stats=$(display_stats)
  echo ${stats}
}

# Run main driver program
main
