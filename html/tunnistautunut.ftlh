<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="x-ua-compatible" content="ie=edge">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.rawgit.com/twbs/bootstrap/v4-dev/dist/css/bootstrap.css">
    <link rel="stylesheet" href="dist/css/bootstrap.css">
    <link rel="stylesheet" href="dist/css/bootstrap.css.map">
    <link rel="stylesheet" href="dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="dist/css/bootstrap.min.css.map">
    <link rel="stylesheet" href="dist/css/custom.css">
    <link rel="stylesheet" href="dist/css/color-scheme-default.css">
    <!-- <link rel="stylesheet" href="dist/css/color-scheme-green.css"> -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">

    <link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet' type='text/css'>

</head>
  <body>

    <!-- HEADER BAR-->
      <nav class="navbar navbar-full navbar-dark navbar-bg-color header-bar">
        <div class="container">
          <a class="navbar-brand" href="#">SUOMI.FI-TUNNISTAMINEN</a>
          <a class="navbar-brand" href="#"><span class="tag label-bg-color tag-header">TESTIPALVELU</span></a>
        </div>
      </nav>


    <div class="container">

        <div class="card card-block white-card">

          <div class="alert alert-success tunnistautunut-alert" role="alert">
              <strong><i class="fa fa-check" aria-hidden="true"></i> Olet kirjautunut testipalveluun!</strong>
          </div>

          <h3 class="card-title header-color"> Suomi.fi-tunnistamisen välittämät tiedot käyttäjästä</h3>

                        <div class="table-responsive">

                            <table class="table table-striped">
                                <tbody>
                                  <thead class="thead-inverse">
                                    <th>
                                      <i class="fa fa-user" aria-hidden="true"></i> Henkilötiedot
                                    </th>
                                    <th></th>
                                  </thead>
                                  <#if KAPA_HETU??>
                                  <tr>
                                      <td width="30%"><strong>Henkilötunnus</strong></td>
                                      <td width="70%">${KAPA_HETU}</td>
                                  </tr>
                                  </#if>
                                  <#if KAPA_PERSON_IDENTIFIER??>
                                  <tr>
                                      <td width="30%"><strong>Henkilön tunniste</strong></td>
                                      <td width="70%">${KAPA_PERSON_IDENTIFIER}</td>
                                  </tr>
                                  </#if>
                                  <#if KAPA_DATE_OF_BIRTH??>
                                  <tr>
                                      <td width="30%"><strong>Syntymäaika</strong></td>
                                      <td width="70%">${KAPA_DATE_OF_BIRTH}</td>
                                  </tr>
                                  </#if>
                                  <#if KAPA_ETUNIMET??>
                                  <tr>
                                      <td><strong>Etunimet</strong></td>
                                      <td>${KAPA_ETUNIMET}</td>
                                    </tr>
                                  </#if>
                                  <#if KAPA_SUKUNIMI??>
                                    <tr>
                                      <td><strong>Sukunimi</strong></td>
                                      <td>${KAPA_SUKUNIMI}</td>
                                    </tr>
                                  </#if>
                                  <#if KAPA_CN??>
                                    <tr>
                                      <td><strong>Koko nimi</strong></td>
                                      <td>${KAPA_CN}</td>
                                    </tr>
                                  </#if>
                                  <#if KAPA_TOKEN??>
                                    <tr>
                                      <td><strong><span id="token_toggle" style="cursor: pointer;">Token</span></strong></td>
                                      <td>&#x2714;</td>
                                    </tr>
                                    <tr id="kapa_token" style="display: none;">
                                      <td colspan="2"><span style="font:monospace;">${KAPA_TOKEN}</span></td>
                                    </tr>
                                  </#if>
                                  <thead class="thead-inverse">
                                    <th>
                                      <i class="fa fa-map-marker" aria-hidden="true"></i> Vakinainen kotimainen lähiosoite
                                    </th>
                                    <th></th>
                                  </thead>
                                   <tr>
                                      <td><strong>Katuosoite</strong></td>
                                      <td>${KAPA_KATU!"-"}</td>
                                    </tr>
                                    <tr>
                                      <td><strong>Postinumero</strong></td>
                                      <td>${KAPA_POSTINUMERO!"-"}</td>
                                    </tr>
                                    <tr>
                                      <td><strong>Postitoimipaikka</strong></td>
                                      <td>${KAPA_PTP!"-"}</td>
                                    </tr>

                                </tbody>
                            </table>
                      </div>

        </div>

        <div class="card card-block white-card2">
            <a class="btn btn-primary btn-lg" href="/Shibboleth.sso/Logout?return=/uloskirjautunut" role="button"><i class="fa fa-sign-out" aria-hidden="true"></i> Kirjaudu ulos palvelusta</a>
        </div>


    </div> <!-- .CONTAINER -->


    <!-- FOOTER -->
      <nav class="navbar navbar-full navbar-dark footer-bg-color footer">
        <div class="container">

          <div class="row">
              <div class="col-md-6">
                <p><strong>SUOMI.FI-TUNNISTAMINEN</strong>
                  <span class="tag label-bg-color tag-footer">TESTIPALVELU</span></p>
                <p>Tämä on testipalvelu, jonka avulla voit testata Suomi.fi-tunnistamisen kertakirjautumista ja kertauloskirjautumista oman asiointipalvelusi testiympäristön kanssa.</p>
              </div>
              <div class="col-md-6">
                  <p><strong>PALVELUNTARJOAJA</strong><br>
                  Väestörekisterikeskus</p>
                  <p><strong>OTA YHTEYTTÄ</strong><br>
                  <a class="footer-link" href="">kapa-asiakaspalvelu@vrk.fi</a></p>

              </div>
            </div>
        </div>
      </nav>



    <!-- jQuery first, then Bootstrap JS. -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
    <script src="https://cdn.rawgit.com/twbs/bootstrap/v4-dev/dist/js/bootstrap.js"></script>
    <script>
      $(document).ready(function() {
        $('#token_toggle').click(function(){
          //e.preventDefault();
          var elem = $('#kapa_token');
          elem.toggle('fast');
        });
      });
    </script>
  </body>
</html>
