# Bootstrap Tour Extras
Some tools and themes to extend [Bootstrap Tour](http://bootstraptour.com): Cross-domain localStorage, popup themes.
# Cross domain storage
[Bootstrap Tour](http://bootstraptour.com) uses by default the HTML5 LocalStorage API to store locally informations like the current step of your tour. But HTML LocalStorage doesn't work  when your application uses subdomains. The CDStorage solves this by storing informations using cookie on top of your application base domaine name .
First, include the `cdstorage.js` in your application and use it for bootstrap-tour storage:

    <script type="text/javascript" src="cdstorage.js"></script>
    <script>
      var tour = new Tour({
        name: "tour",
        storage: window.CDStorage,
        ...
      });
    </script>
# Use a theme
Just add the theme css file in your html file.

    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <title>Demo Page</title>
        <link href="bootstrap.min.css" rel="stylesheet">
        <link href="bootstrap-tour.min.css" rel="stylesheet">
        <link href="theme-cosmos.css" rel="stylesheet">
      </head>
      <body>

      </body>
    </html>
