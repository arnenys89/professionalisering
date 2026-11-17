# Professionalisering — Richtpunt campus Ninove–Zottegem

Digitale applicatie voor het aanvragen, beoordelen en opvolgen van professionaliseringen.

## Status
Eerste technische basis. De Cloudflare Worker en D1-database zijn aangemaakt. Microsoft Entra ID-authenticatie, autorisatie, e-mailverzending en de volledige gebruikersinterface moeten nog worden geconfigureerd en getest. Deze repository bevat dus nog geen productieklare toepassing.

## Architectuur
- Cloudflare Workers: webapplicatie en API
- Cloudflare D1: relationele gegevensopslag
- Microsoft Entra ID: beoogde personeelsauthenticatie via OpenID Connect
- Smartschool: latere integratie, afhankelijk van de officiële SSO-mogelijkheden
- GitHub: broncode en versiebeheer

## Lokale ontwikkeling
1. Installeer Node.js en Wrangler.
2. Voer `npm install` uit.
3. Maak een lokale D1-database aan of koppel de bestaande database via de Cloudflare-instellingen.
4. Voer het schema uit: `wrangler d1 execute richtpunt-professionalisering --local --file=./schema/schema.sql`.
5. Start: `npm run dev`.

## Productie
Controleer eerst `wrangler.toml` en vul het echte D1-database-ID in. Stel geheimen uitsluitend in via Cloudflare secrets, nooit in Git. Deploy met `npm run deploy`.

## Beveiligingsuitgangspunten
- Geen wachtwoorden van Microsoft 365 of Smartschool opslaan.
- Server-side sessies en CSRF-bescherming gebruiken.
- Rollen server-side toekennen; nooit vertrouwen op rolwaarden uit de browser.
- Persoons- en betaalgegevens minimaal verzamelen en afschermen volgens rol.
- Gevoelige wijzigingen registreren in een auditlog.
- De repository bevat geen echte tenantgegevens, tokens of geheimen.

## Functionele modules
Aanvragen met meerdere deelnemers en acht lesuren per dag; principiële TAC/TA-goedkeuring; quota per schooljaar en categorie; betaling door econoom; PICTO-registratie; vervangingsmelding; maandelijkse herinneringen; persoonlijke historiek; opvolging na de opleiding; rapportering en Excel-export.
