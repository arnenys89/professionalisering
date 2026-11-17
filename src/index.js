const html = `<!doctype html>
<html lang="nl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="theme-color" content="#d7ad01">
<title>Professionalisering | Richtpunt</title>
<style>
:root{font-family:Arial,Helvetica,sans-serif;color:#222;background:#f4f4f4;--yellow:#d7ad01;--grey:#555}
*{box-sizing:border-box}body{margin:0}header{background:var(--yellow);color:#fff;padding:34px 22px}
header,main{width:100%}.wrap{max-width:960px;margin:auto}main{padding:32px 18px}.panel{background:#fff;border-radius:12px;padding:28px;box-shadow:0 3px 16px #0000000d}
h1{margin:0 0 8px;font-size:clamp(26px,5vw,36px)}h2{color:var(--grey);margin-top:0}
.notice{margin-top:22px;padding:16px;border-left:4px solid var(--yellow);background:#fff8dc;line-height:1.6}
footer{padding:20px;color:#666;text-align:center;font-size:13px}
</style>
</head>
<body>
<header><div class="wrap"><h1>Professionalisering</h1><div>Richtpunt campus Ninove – Zottegem</div></div></header>
<main class="wrap"><section class="panel">
<h2>Digitaal professionaliseringsplatform</h2>
<p>Hier kunnen personeelsleden professionaliseringsactiviteiten aanvragen en opvolgen. De applicatie ondersteunt de beoordeling, financiële afhandeling, registratie en evaluatie.</p>
<div class="notice"><strong>Opstartfase</strong><br>De technische basis is beschikbaar. De beveiligde aanmelding en de gebruikersmodules worden stapsgewijs geactiveerd. Aanmelden is nog niet beschikbaar.</div>
</section></main>
<footer>Richtpunt campus Ninove – Zottegem</footer>
</body></html>`;

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === "/health") {
      return Response.json({ ok: true, application: "Professionalisering", databaseConfigured: Boolean(env.DB) });
    }
    if (url.pathname.startsWith("/api/")) {
      return Response.json({ error: "Deze API-module is nog niet geactiveerd." }, { status: 501 });
    }
    return new Response(html, {
      headers: {
        "content-type": "text/html; charset=utf-8",
        "x-content-type-options": "nosniff",
        "referrer-policy": "strict-origin-when-cross-origin",
        "cache-control": "no-store"
      }
    });
  }
};
