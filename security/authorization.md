# A. Direct Authorization:

## 1. API Tokens (Personal Access Tokens, Static Tokens)

- Long-lived secrets created by a service and handed to user manually (e.g. GitHub personal access tokens).
- They are random strings stored and checked by the API.
- **Pros:** Simple, no OAuth flow needed.
- **Cons:** Harder to manage/rotate securely, usually tied to one user.


### 2. JWTs Authentication/Authorization

- The backend itself is both the Identity Provider and the Resource Server.
- User enters credentials (username/password).
- If valid → backend signs and returns a JWT (access token).
	- Browser can store the JWT in localStorage or memory which is not secure.
		- On every request → `Authorization: Bearer <token>.`header should be included.
		- Don't pass the token as query string since can be seen in the browser history.
	- The backend can put the JWT in a cookie (with HttpOnly and Secure flags) which is more secure. Since there is no database session, this method is still stateless.
		- `Set-Cookie: access_token=<JWT>; HttpOnly; Secure; SameSite=Lax; Path=/`
		- On every request to your backend, the cookie is included: `Cookie: access_token=<JWT>`

- **Pros:**
	- Simple to implement.
	- Stateless, scales well (need for backend session storage).
- **Cons:**
	- Not standardized, can easily get wrong (e.g. long-lived tokens, weak signing, no refresh token system).
	- Security details (expiration, refresh, revocation, rotation) are your responsibility.

**For Authorization:**
- Backend verifies the JWT signature and grants/denies access.
- By adding scope to payload we can do authorization as well.
	- `"scope": "read:orders write:orders"`

----

# B. Delegated/Third-Party Authorization (OAuth 2.0):

## Summary of OAuth 2.0 GrantTypes/Flows

- **Web apps** → Authorization Code
- **Mobile/SPAs** → Authorization Code with PKCE
- **Backend services** → Client Credentials
- **Smart devices** → Device Code
- **Legacy** →
	- Password Grant
	- Implicit

## 1. Authorization Code Flow
**Use case:** Web apps and mobile apps that can keep a client secret safe.

**How it works:**
- User is redirected to the authorization server.
- After login/consent, the server sends an authorization code back to the client (via redirect URI).
- The client exchanges that code (plus its client secret) for an access token.

**Benefits:** Secure, since tokens aren’t exposed in the browser; code is exchanged server-to-server.

---

## 2. Authorization Code Flow with PKCE (Proof Key for Code Exchange)
**Use case:** Mobile or SPA (Single Page Applications) that can’t safely store a client secret.

**How it works:** Same as the normal code flow, but adds a code challenge and code verifier. This prevents attacks where the authorization code could be intercepted.

**Benefits:** Stronger security, recommended for native/mobile apps.

---

## 3. Client Credentials Flow
**Use case:** Machine-to-machine communication (backend services, daemons, cron jobs) with no user interaction.

**How it works:** The client app directly requests a token by presenting its client ID and secret to the authorization server. No user involved.

**Benefits:** Simple, suitable for trusted server-to-server integrations.

---

## 4. Resource Owner Password Credentials Flow (Password Grant)
**Use case:** Legacy scenarios, where the app directly collects the user’s username and password.

**How it works:** Client sends username + password to authorization server to get a token.

**Drawbacks:** Discouraged now, since the app handles user credentials directly (bad security practice).

---

## 5. Implicit Flow (almost deprecated)
**Use case:** Historically used by browser-based SPAs.

**How it works:** Tokens were returned directly in the redirect URL (without exchanging an authorization code).

**Drawbacks:** Insecure compared to PKCE, since tokens can be leaked in browser history and logs.

**Status:** Mostly replaced by Authorization Code with PKCE.

---

## 6. Device Authorization Flow (Device Code Flow)
**Use case:** Devices without browsers or with limited input (smart TVs, consoles, IoT devices).

**How it works:**
- Device shows a code to the user.
- The user logs in on another device (phone/laptop) and approves the request.
- The device polls until it receives the token.

**Benefits:** Lets users authorize devices that can’t display full login screens.
