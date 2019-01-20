#!/bin/bash

. $(dirname "$0")/CONFIG

DATA_FILE=$DATA_DIR/log.csv

temp_other=$(cat $DATA_FILE | grep OSv1 | cut -d , -f 6 | tail -1)
date_other=$(cat $DATA_FILE | grep OSv1 | cut -d , -f 1 | cut -d \  -f 1 | tail -1)
time_other=$(cat $DATA_FILE | grep OSv1 | cut -d , -f 1 | cut -d \  -f 2 | tail -1)

temp_my=$(cat $DATA_FILE | grep THN132N | cut -d , -f 6 | tail -1)
date_my=$(cat $DATA_FILE | grep THN132N | cut -d , -f 1 | cut -d \  -f 1 | tail -1)
time_my=$(cat $DATA_FILE | grep THN132N | cut -d , -f 1 | cut -d \  -f 2 | tail -1)

$GIT_BASE/gurke.io/scripts/gen_plot.sh
PLOT=$(base64 /tmp/plot.png)


page="
<!DOCTYPE html>
<html>
<head>
    <title>gurke.io</title>
    <link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css' integrity='sha384-WskhaSGFgHYWDcbwN70/dfYBj47jz9qbsMId/iRN3ewGhXQFZCSftd1LZCfmhktB' crossorigin='anonymous'>

    <style type='text/css'>

        body {
            background-attachment: fixed;
            background-image: url('gurke.jpg');

            background-position: center;
            background-size: cover;
        }

        .jumbotron {
            background-color: transparent;
            margin-bottom: 0;
            padding: 0
        }

        h1.jumbotron-heading {
            font-size: 6rem;
            color: #A00952;
        }

        .card {
            background-color: transparent;
        }

        .table {
            margin-bottom: 0;
        }

        .bg-opa {
            background-color: rgba(255, 255, 255, .8);
        }

    </style>
</head>
<body>
    <main role='main'>

      <section class='jumbotron text-center text-white'>
        <div class='container'>
          <h1 class='jumbotron-heading'>gurke.io</h1>
        </div>
      </section>

      <div class='pb-5'>
        <div class='container'>

          <div class='card mb-4 box-shadow bg-opa'>
            <div class='card-body'>
              <table class='table table-sm'>
                  <tr>
                      <th>Datum</th>
                      <th>Uhrzeit</th>
                      <th>Sensor</th>
                      <th>Temperatur</th>
                      <th>Kommentar</th>
                  </tr>
                  <tr>
                      <td>$date_my</td>
                      <td>$time_my</td>
                      <td>THN132N</td>
                      <td>$temp_my °C</td>
                      <td>Mein Balkon</td>
                  </tr>
                  <tr>
                      <td>$date_other</td>
                      <td>$time_other</td>
                      <td>OSv1 Temperature Sensor</td>
                      <td>$temp_other °C</td>
                      <td>Nachbar</td>
                  </tr>
              </table>
            </div>
          </div>

          <div class='card mb-4 box-shadow'>
            <div class=''>
              <img style='opacity: 0.8; width: 100%' src='data:image/png;base64, $PLOT' alt='Temperatur plot' />
            </div>
          </div>

        </div>
      </div>

      <section class='text-center text-white'>                                                                
        <div class='container' style='height: 32px'>
           <a href="https://github.com/NodyHub/gurke.io"><img style='height: 100%' src='GitHub-Mark-32px.png' alt='GitHub' /></a>
           <a href="https://twitter.com/NodyTweet"><img style='height: 100%' src='Twitter_Logo_Blue.png' alt='Twitter' /></a>
        </div>
      </section>


    </main>

</body>
</html>
"

echo $page | ssh $WEBHOST "cat > $WEBDIR/index.html"

exit 0

