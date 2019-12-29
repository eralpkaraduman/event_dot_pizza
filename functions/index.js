const functions = require("firebase-functions");
const fetch = require("node-fetch");
const url = require("url");
const {
  EVENTBRITE_CLIENT_SECRET,
  MEETUP_CLIENT_SECRET
} = require("./secrets.json");

const config = {
  eventbrite: {
    clientId: "DIHW55JS4TOM7O5IA5",
    clientSecret: EVENTBRITE_CLIENT_SECRET,
    redirectUri:
      "https://us-central1-eventdotpizza.cloudfunctions.net/handle_eventbrite_redirect",
    tokenUri: "https://www.eventbrite.com/oauth/token",
    callbackUri: "event.pizza://handle_eventbrite_redirect"
  },
  meetup: {
    clientId: "96rf1kn6pobffcejakptjgarrf",
    clientSecret: MEETUP_CLIENT_SECRET,
    redirectUri:
      "https://us-central1-eventdotpizza.cloudfunctions.net/handle_meetup_redirect",
    tokenUri: "https://secure.meetup.com/oauth2/access",
    callbackUri: "event.pizza://handle_meetup_redirect"
  }
};
const EVENTBRITE_AUTH_URI = `https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=${config.eventbrite.clientId}&redirect_uri=${config.eventbrite.redirectUri}`;
const MEETUP_AUTH_URI = `https://secure.meetup.com/oauth2/authorize?client_id=${config.meetup.clientId}&response_type=code&redirect_uri=${config.meetup.redirectUri}`;

async function handleOauth2Redirect(
  request,
  response,
  { clientId, clientSecret, redirectUri, tokenUri, callbackUri }
) {
  const code = request.query.code;
  if (!code) {
    response.status(400).json({ error: "code" });
    return;
  }
  const body = new url.URLSearchParams();
  body.append("grant_type", "authorization_code");
  body.append("client_id", clientId);
  body.append("client_secret", clientSecret);
  body.append("code", request.query.code);
  body.append("redirect_uri", redirectUri);
  const oauthResponse = await fetch(tokenUri, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body
  });
  if (oauthResponse.status !== 200) {
    response.redirect(`${callbackUri}?error=${oauthResponse.statusText}`);
  } else {
    const oauthJson = await oauthResponse.json();
    response.redirect(`${callbackUri}?access_token=${oauthJson.access_token}`);
  }
}

exports.authorize_eventbrite = functions.https.onRequest((request, response) =>
  response.redirect(EVENTBRITE_AUTH_URI)
);

exports.handle_eventbrite_redirect = functions.https.onRequest((req, res) =>
  handleOauth2Redirect(req, res, config.eventbrite)
);

exports.authorize_meetup = functions.https.onRequest((request, response) =>
  response.redirect(MEETUP_AUTH_URI)
);

exports.handle_meetup_redirect = functions.https.onRequest((req, res) =>
  handleOauth2Redirect(req, res, config.meetup)
);
