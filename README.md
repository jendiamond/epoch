epoch
=====

test site for epoch

Fetching data and inserting to DB:
    1. Create a rails app.
    2. Create a Fetch Model with Controllers and Views with a form that takes a url. See example from http://www.githubarchive.org. ( eg. http://data.githubarchive.org/2014-01-01-1.json.gz )
    3. With the URL that was input through the form, fetch data for the 'entire day of 2014-01-01' and insert them into a database.

Displaying a report:
    1. Create another model called Report with controllers and views.
    2. Here you will create a form that will take a time range (put this in a partial so it can be reused). Query your database for the 'type' of 'PushEvent' within that time range.
    3. Output the results in a bar graph showing only the top ten ['repository']['name'] and the count. (hint some ['repository']['name'] have multiple PushEvents)
    4. Create a second page that outputs the results in a datatable showing only the top 25 by ['repository']['name'], ['repository']['url'], and count. Hyperlink the name to the repository url.

    (Hint: here's a plugin that helps draw datatables - https://datatables.net)

Extra Credit:
    1. Give the report a dropdown option for all EventTypes that gets the same report via ajax.
    2. Add styling using Twitter Bootstrap.
