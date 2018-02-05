# Highrise => Active Campaign

## Migrating contacts

### In Highrise
- Export CSV from Highrise

### Locally
- Move it to `/data/csv/contacts.csv`
- Run `./bin/sanitize_contacts_csv.rb`
- Verify successful creation of `/data/csv/contacts.out.csv`
- Make sure all contacts are deleted from Active Campaign

### In Active Campaign
- Set environment variables
- Import resulting CSV from within Active Campaign
    + Make sure to map create custom fields for all columns
    + Map the "Highrise ID" column to a custom field named "Highrise ID"!
- Add everyone to a list (e.g. the "Everyone" list)

## Migrating emails, notes and comments

### In Highrise
- Export notes and emails as ZIP

### Locally
- Copy all `.txt` files from the `/contacts` folder contained by the ZIP file to this project's `/data/yaml` folder
- Set the `AC_API_URL` and `AC_API_KEY` environment variables to Active Campaign's admin user's credentials. Note that the URL needs to be postfixed with `/admin/api.php`.
- Run `./bin/import_notes_and_emails.rb`

### In Active Campaign
- Verify success :balloon:

