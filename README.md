# Unraid Template for Internxt CLI WebDAV Server

This is a stable and configurable Unraid Docker template for the official [Internxt CLI](https://github.com/internxt/cli). It provides a reliable WebDAV server for your Internxt Drive, allowing you to use tools like rclone for backups and file access.

This template was created to solve common issues with existing solutions, ensuring a stable network connection (`bridge` mode) and providing a clean, automated login process.

---

## How to Install

1.  Go to the **Apps** tab in your Unraid dashboard.
2.  If you haven't already, add this repository to your template repositories under **Settings**.
3.  Search for `Internxt-CLI-WebDAV`.
4.  Click **Install** and fill in the required fields:
    * **WebDAV Port:** The external port for the service (default is `7111`).
    * **Appdata:** The path for the persistent configuration file.
    * **Email:** Your Internxt account email.
    * **Password:** Your Internxt account password.
5.  After installation, the WebDAV server will be available at `http://<YOUR-UNRAID-IP>:<HOST-PORT>`.

## Configuration for rclone

Use the following settings when configuring a new WebDAV remote in rclone:

* **URL:** `http://<YOUR-UNRAID-IP>:7111`
* **Vendor:** `Other`
* **User:** Your Internxt email
* **Password:** Your Internxt password

---

## Why this template?

This template was built from the ground up to be:
* **Stable:** Uses the recommended `bridge` network mode to avoid IP conflicts.
* **Robust:** The container is built on a full Debian image with all necessary dependencies, avoiding runtime errors.
* **Automated:** The login process is handled automatically on startup.
* **Diagnosable:** The start-up script includes clear logging for internet connection tests (Ping) and server handshake verification (SSL Certificate Check) to make troubleshooting easy.
