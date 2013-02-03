Feature: Top Songs
  In order to display top songs converted
  As as developer
  I want to connect to a database & output results 

  Scenario: Display Top 5 Chipmunked Songs
  When I connect to mongohq
  And I grab all of the available collections
  And I search for the top five chipmunked songs
  Then I should get a valid json response
  