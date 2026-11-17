# Microsoft 365-aanmelding — Microsoft Entra ID

## Beoogde implementatie
Gebruik OpenID Connect Authorization Code Flow met PKCE. De browser ontvangt nooit een client secret. De Worker valideert de ID-token (handtekening, issuer, audience, nonce, state en tijdsclaims) en controleert dat de gebruiker tot de toegelaten schooltenant behoort.

## Nog te configureren
- Tenant-ID van de school
- Application (client) ID
- Client secret of certificaat, uitsluitend als Cloudflare secret
- Exacte Worker callback-URL
- Toegestane tenant en eventuele toegestane e-maildomeinen
- Appregistratie en vereiste Graph-toestemmingen, indien functie/jobTitle via Microsoft Graph wordt opgehaald

## Callback
Kies pas de definitieve redirect URI nadat de Worker-URL is bevestigd. Registreer exact dezelfde URI in Entra ID. Gebruik HTTPS.

## Beveiliging
- Geen wachtwoorden opslaan of verwerken.
- Tokens en client secrets nooit committen.
- Sessies server-side opslaan of met een aantoonbaar veilige sessieoplossing beheren.
- Cookies: Secure, HttpOnly en SameSite=Lax of strenger waar compatibel.
- State, nonce, PKCE en CSRF-controles verplicht.
- Rollen uitsluitend server-side beheren; een succesvolle Microsoft-login geeft niet automatisch een beheerdersrol.
- Beperk Graph-toestemmingen tot wat noodzakelijk is.
- Voorzie accountdeactivering en sessie-intrekking.

## Openstaande beslissing
De administrator wordt initieel handmatig en gecontroleerd toegewezen. De precieze Entra-tenantgegevens moeten door de school-ICT-beheerder worden aangeleverd.
