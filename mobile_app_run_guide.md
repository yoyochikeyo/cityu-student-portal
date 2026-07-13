# Mobile App Preview Guide

## Preview In Browser

Open this file directly for normal preview:

`index.html`

## Preview As Installable Mobile App

PWA installation needs localhost or HTTPS.

From the `outputs` folder, run a local server:

```bash
python -m http.server 8080
```

Then open:

```text
http://localhost:8080/
```

In Chrome:

1. Open DevTools.
2. Click Toggle Device Toolbar.
3. Choose a phone size.
4. Open the browser menu.
5. Choose Install app or Add to Home Screen.

## Main Files

- `index.html` - mobile app UI and logic for deployment
- `student_portal_preview.html` - editable backup of the same app
- `manifest.webmanifest` - app install metadata
- `sw.js` - offline cache service worker
- `assets/cityu-logo-mark.png` - app icon/logo
- `assets/campus-hall-preview.jpg` - dashboard image
