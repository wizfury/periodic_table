PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

NOT_FOUND()
{
  echo "I could not find that element in the database."
}

#if no arguments
if [[ -z $1 ]];
then
  echo "Please provide an element as an argument."

#if argument is atomic number
elif [[ $1 =~ ^[0-9]+$ ]];
then
  #get the details of element.
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number=$1;")
  

  #if element not found
  if [[ -z $ELEMENT ]];
  then
    NOT_FOUND

  #if element found
  else
    echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
    do
      TYPE=$($PSQL "select type from properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
  
  
#if argument is Symbol
elif [[ $1 =~ ^[A-Z][a-z]?$ ]];
then
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE symbol='$1';")
  #if not found
  if [[ -z $ELEMENT ]];
  then
    NOT_FOUND
  #if found
  else
    echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
    do
      TYPE=$($PSQL "select type from properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi


#if argument is Atomic name
elif [[ $1 =~ ^[A-Za-z]+$ ]];
then
  ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) where name='$1';")
  

  #if not found
  if [[ -z $ELEMENT ]];
  then
    NOT_FOUND

  #if  found
  else
    echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE_ID
    do
      TYPE=$($PSQL "select type from properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  fi
  

 


else
  echo "I could not find that element in the database."
fi


