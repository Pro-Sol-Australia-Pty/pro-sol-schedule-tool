# Pro-Sol Schedule Tool

Static GitHub Pages deployment for the Pro-Sol Schedule Tool, with optional Supabase cloud persistence.

## Repository Layout

- `public/index.html` - the browser app.
- `public/config.js` - runtime database configuration used by the deployed site.
- `public/config.example.js` - sample Supabase configuration.
- `database/supabase/schema.sql` - database table, trigger, and Row Level Security policies.
- `.github/workflows/deploy-pages.yml` - GitHub Actions workflow that deploys `public/` to GitHub Pages.

## Run Locally

```powershell
python -m http.server 8000 -d public
```

Open `http://localhost:8000`.

The tool works without Supabase. In that mode, `Save Table Changes` stores data in the current browser only.

## Enable the Database

1. Create a Supabase project.
2. Open the Supabase SQL Editor and run `database/supabase/schema.sql`.
3. In Supabase, copy the Project URL and `anon public` key.
4. For local testing, paste them into `public/config.js`.
5. For GitHub Pages, add repository secrets:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
6. Optional: add repository variable `SCHEDULE_SLUG` if you change the slug from `default`.

After configuration, the app shows `Load Cloud` and `Save Cloud` buttons next to the existing local save button.

## Deploy to GitHub Pages

1. Create a new GitHub repository.
2. Push this folder to the repository's `main` branch.
3. In GitHub, go to `Settings > Pages`.
4. Set `Build and deployment` to `GitHub Actions`.
5. Push again or run the `Deploy GitHub Pages` workflow manually.

## Database Access Note

The included Supabase policies allow anyone who can access the page to read and update the `default` schedule. That is the simplest shared-editor setup for an internal team link. For stricter control, add Supabase Auth before sharing the page publicly.
