# Unraid Template for Internxt CLI WebDAV Server

This is a stable and configurable Unraid Docker template for the official [Internxt CLI](https://github.com/internxt/cli). It provides a reliable WebDAV server for your Internxt Drive, allowing you to use tools like rclone for backups and file access.

This template was created from the ground up to solve common issues with existing solutions by providing a stable network configuration and a robust, fully automated login process.

---

## How to Install (via Community Applications)

1.  Go to the **Apps** tab in your Unraid dashboard.
2.  Search for `Internxt-CLI-WebDAV`.
3.  Click **Install** and fill in the required fields:
    * **WebDAV Port:** The external port for the service (default is `7111`).
    * **Appdata:** The path for the persistent configuration file.
    * **Email:** Your Internxt account email.
    * **Password:** Your Internxt account password.
4.  After installation, the WebDAV server will be available at `http://<YOUR-UNRAID-IP>:<HOST-PORT>`.

## Configuration for rclone

Use the following settings when configuring a new WebDAV remote in rclone:

* **URL:** `http://<YOUR-UNRAID-IP>:7111`
* **Vendor:** `Other`
* **User:** Your Internxt email
* **Password:** Your Internxt password

---

## Why this template?

This template was built from the ground up to be:
* **Stable:** Uses the recommended `bridge` network mode to avoid IP conflicts and ensure reliable internet access.
* **Robust:** The container is built on a full Debian image with all necessary dependencies, preventing runtime errors.
* **Reliably Automated:** The login process is handled by a sophisticated `expect` script, simulating a human user to overcome bugs in the official CLI tool's non-interactive mode.
* **Persistent:** Correctly uses a mapped `appdata` path to store the login session, so the automated login only needs to run once.

This project was a effort to create the most stable Internxt WebDAV solution for Unraid.
