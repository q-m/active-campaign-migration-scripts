# Highrise => Active Campaign

## Migrating contacts

### In Highrise
- Export CSV from Highrise

### Locally
- Run it through `./bin/sanitize_contacts_csv.rb`
- Make sure all contacts are deleted from Active Campaign

### In Active Campaign
- Import resulting CSV from within Active Campaign
    + Make sure to map create custom fields for all columns
- Add everyone to a list (e.g. the "Everyone" list)

## Migrating emails, notes and comments

### In Highrise
- Export notes and emails as ZIP

### Locally
- Copy all `.txt` files from the `/contacts` folder contained by the ZIP file to this project's `/data` folder
- Set the `AC_API_URL` and `AC_API_KEY` environment variables to Active Campaign's admin user's credentials
- Run `./bin/import_notes_and_emails.rb`

### In Active Campaign
- Verify success :balloon: