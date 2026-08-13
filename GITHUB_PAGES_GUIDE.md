# Publish this portfolio with GitHub Pages

This repository is configured for:

`https://jay07-beep.github.io/jerome-portfolio/`

## First publication

1. Push the complete project to the `main` branch of the public GitHub repository `jay07-beep/jerome-portfolio`.
2. On GitHub, open **Settings → Pages**.
3. Under **Build and deployment**, choose **GitHub Actions** as the source.
4. Open the **Actions** tab and wait for **Deploy portfolio to GitHub Pages** to finish.

## Later updates

After editing and saving the files locally:

```powershell
git add .
git commit -m "Update portfolio"
git push
```

The workflow republishes the site automatically after every push to `main`.
