---
title: Install the WebhookDB CLI
layout: home
parent: Getting started
nav_order: 10
---

# Install the WebhookDB CLI

WebhookDB is a single binary (written in Go) that should work on pretty much any OS.
It's also installable through package managers.

To get started, we recommend using our WASM-based [terminal in your browser](https://webhookdb.com/terminal/).
This avoids having to install anythinig locally.

You can find the CLI source [on GitHub](https://github.com/webhookdb/cli).

## <i class="fa-brands fa-apple"></i> MacOS

The easiest option is to use Homebrew:

    brew install webhookdb/webhookdb-cli/webhookdb

This adds `webhookdb` to your `PATH`.

Alternatively, you can download and extract the binary:

1. Download the latest MacOS `tar.gz` file from
[https://github.com/webhookdb/webhookdb-cli/releases/latest](https://github.com/webhookdb/webhookdb-cli/releases/latest). **Make sure you choose the right architecture**. M1 Macs use the ARM (`arm64`) binary, others use AMD (`x86_64`).
2. Unzip the file: `tar -xvf webhookdb_X.X.X_macos_x86_64.tar.gz`.<br />
   For ARM (M1 Macs) it would be: `tar -xvf webhookdb_X.X.X_macos_arm64.tar.gz`.
3. Move `./webhookdb` to your execution path, like `/usr/local/bin`.
4. Run `webhookdb version` to test.

## <i class="fa-brands fa-linux"></i> Linux

1. Download the latest Linux `tar.gz` file from
   [https://github.com/webhookdb/webhookdb-cli/releases/latest](https://github.com/webhookdb/webhookdb-cli/releases/latest). **Make sure you choose the right architecture**. M1 Macs use the ARM (`arm64`) binary, others use AMD (`x86_64`).
2. Unzip the file: `tar -xvf webhookdb_X.X.X_linux_x86_64.tar.gz`.
3. Move `./webhookdb` to your execution path, like `/usr/local/bin`.
4. Run `webhookdb version` to test.

## <i class="fa-brands fa-windows"></i> Windows

1. Download the latest Windows `zip` file from
   [https://github.com/webhookdb/webhookdb-cli/releases/latest](https://github.com/webhookdb/webhookdb-cli/releases/latest). **Make sure you choose the right architecture**. M1 Macs use the ARM (`arm64`) binary, others use AMD (`x86_64`).
2. Unzip the file: `tar -xvf webhookdb_X.X.X_windows_x86_64.zip`.
3. Run `webhookdb.exe version` to test.

{% include prevnext.html prev="docs/getting-started/index.md" next="docs/getting-started/auth.md" %}
