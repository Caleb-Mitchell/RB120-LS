
# Problem

  - build different personalities for each robot, based on the name

# Example

  - Computer object with name 'R2D2' will always choose rock.
  - Computer object with name 'Hal' will often choose scissors, rarely
    choose rock, and never paper.
  - Computer object with name 'Chappie' will always choose paper.

# Data Structure

  - Hash, with names associated with personalities.
  - Personalities can be keys for new distinct 'VALID_CHOICES' constants within
    PLayer class.

    
    TODO: Do i need '!' for updating methods?
%% # TODO: make attr method for personality private?
%% # TODO: find bug? ( I THINK I FOUND )
%% # TODO: clear record each game
%% # TODO: switch computer player each game
%% # TODO: set_new_computer changes name but loses personality
