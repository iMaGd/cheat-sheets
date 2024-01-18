
## Cookies and Sessions

### Types of Cookies
- Session Cookies: don’t have an expiration date, keep information about what the user does during a single session. stored temporarily in memory and are automatically removed when the browser closes or the session ends.
- Persistent Cookies: contain an expiration date, and last much longer and are stored on disk until they expire or are manually cleared by the user. Sometimes are called “tracking cookies,” as these are the types of cookies that Google Analytics, AdRoll, Stripe, etc. all use.


## WordPress Cookies:
- Login Cookies
	- wordpress_[hash]
	- wordpress_logged_in_[hash]
	- wp-settings-{time}-[UID]

- Comment Cookies
	- comment_author_[hash]
	- comment_author_email_[hash]
	- comment_author_url_[hash]

- WooCommerce Cookies:
	- woocommerce_cart_hash
	- woocommerce_items_in_cart
	- wp_woocommerce_session_ : contains a unique code for each customer which corresponds to an entry in the custom wp_woocommerce_sessions table in the database.
