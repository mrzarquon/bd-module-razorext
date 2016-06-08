# razorext #

This module enables the microkernel extensions feature for Razor in PE environments

To use this module, include this class along with the pe_razor class.

It performs three tasks:

- Ensures that the zip and rsync packages are installed on the Razor server
- Enables the extension-zip option in the Razor server configuration
- Performs an exec that creates does the following
  - Rsync all the pluginsynced facts from the puppet client to a staging directory
  - If the rsync indicates it had to update the staging directory, rebuilds the zip

This module now makes it possible that any fact in the same Puppet environment as
the razor server will now automatically be added to the extension-zip file and
therefore become available as a fact to be used in any Razor policy or rule.
