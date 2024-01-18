
### Enable additional CSS on WP multisite:

```php
function phlox_multisite_custom_css_map_meta_cap( $caps, $cap, $user_id ) {
    if ( 'edit_css' === $cap && is_multisite() && user_can( $user_id, 'manage_options' ) ) {
        $caps = array( 'edit_theme_options' );
    }
    return $caps;
}
add_filter( 'map_meta_cap', 'phlox_multisite_custom_css_map_meta_cap', 20, 3 );
```
