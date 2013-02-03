Feature: Top Songs
  In order to display top songs converted
  As as developer
  I want to connect to a database & output results 

  Scenario: Display Top 5 Songs
  When I connect to mongohq
  And query the database for the top 5 songs
  Then I should get a json response with 5 items
  