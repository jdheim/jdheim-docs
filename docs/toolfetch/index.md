---
title: ToolFetch
---

# ToolFetch

**ToolFetch** is a CLI for **fetching and installing external tools**
from release URLs (e.g. GitHub releases) using a YAML configuration file.

It is designed for:

- setting up new developer machines quickly and consistently
- reproducible tool installations

Installation demo using [toolfetch.yaml](https://github.com/jdheim/toolfetch/blob/main/assets/tapes/toolfetch.yaml):

![Demo](https://raw.githubusercontent.com/jdheim/toolfetch/refs/heads/main/assets/demo.gif)

## Installation

1. Download the latest release for your OS/architecture from [Releases](https://github.com/jdheim/toolfetch/releases).
2. Extract the archive into your chosen installation directory.
3. On Linux, open a terminal in the installation directory and make the binary executable:

     ```shell
     chmod +x bin/toolfetch
     ```

4. Create a symlink in a directory on your `$PATH`. Replace `/path/to/installation/bin/toolfetch` with the absolute path to the extracted binary.
   Choose one of the following:

     For your user:
     ```shell
     mkdir -p "$HOME/.local/bin"
     ln -s /path/to/installation/bin/toolfetch "$HOME/.local/bin/toolfetch"
     ```
   
     If `$HOME/.local/bin` is not already on your `$PATH`, add this line to your shell startup file (e.g., `~/.bashrc` or `~/.zshrc`), then open a new
     terminal:
     ```shell
     export PATH="$HOME/.local/bin:$PATH"
     ```

     Or, system-wide:
     ```shell
     sudo mkdir -p /usr/local/bin
     sudo ln -s /path/to/installation/bin/toolfetch /usr/local/bin/toolfetch
     ```

5. Verify the installation:

      ```shell
      toolfetch --help
      ```

Keep the extracted binary in place so the symlink continues to work.

## Verify Releases

See [VERIFICATION.md](https://github.com/jdheim/toolfetch/blob/main/VERIFICATION.md) for details.

## Usage

Given the following configuration file named `toolfetch.yaml`:

```yaml
destination: "/opt"
tools:
  - id: "toolfetch"
    url: "https://github.com/jdheim/toolfetch/releases/download/v0.0.7/toolfetch-0.0.7-linux-amd64.tar.gz"
```

When you invoke the command: `toolfetch install`, the latest version of the tool will be installed like this:

```shell
/opt
|-- toolfetch
```

!!! note

    The configuration file is autodetected as `toolfetch.yaml` or `toolfetch.yml` in the current directory.
    You can customize the configuration path with `-c` or `--config`, for example: `toolfetch install --config "path/to/config.yaml"`.

---

You can use optional placeholder: `${version}` in `url` which will be replaced with `version` value at runtime:

```yaml
destination: "/opt"
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
  - id: "intellij-idea"
    version: "2026.2.3"
    url: "https://download.jetbrains.com/idea/idea-${version}.tar.gz"
```

When you invoke the command again, tools will be installed like this:

```shell
/opt
|-- intellij-idea
|-- toolfetch
```

---

You can optionally define a `destination` key for a specific tool to install it somewhere else:

```yaml
destination: "/opt"
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
    destination: "best-tools" # or absolute path: "/opt/best-tools"
  - id: "intellij-idea"
    version: "2026.2.3"
    url: "https://download.jetbrains.com/idea/idea-${version}.tar.gz"
```

Now, when you invoke the same command, tools will be installed like this:

```shell
/opt
|-- intellij-idea
|-- best-tools
    |-- toolfetch
```

---

### Checksum Verification Formats

You can optionally define a `checksums` key for a specific tool to verify the downloaded archive before it is extracted:

```yaml
destination: "/opt"
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
    checksums:
      sha256: "b505e3f905c9440f7719bf7b97e8e42f1d2dadc864223add1a759885c2935281"
  - id: "intellij-idea"
    version: "2026.2.3"
    url: "https://download.jetbrains.com/idea/idea-${version}.tar.gz"
    checksums:
      sha256: "68751c8ae4d49407251cd197df795fbed91b6fdc85d10c73c4649a99e496ab37"
```

Currently, the following Checksum Verification Formats are supported:

- `sha256`
- `sha384`
- `sha512`

---

### Environment Variables

You can optionally use environment variables in `toolfetch.yaml` using either `$VAR` or `${VAR}` syntax.

Currently supported in:

- `destination`
- `http.ssl.trustStore.path`
- `tools[].destination`

Example:

```yaml
destination: "$HOME/tools"
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
    destination: "${DEV_HOME}/best-tools"
  - id: "intellij-idea"
    version: "2026.2.3"
    url: "https://download.jetbrains.com/idea/idea-${version}.tar.gz"
```

---

### HTTP Client Settings

You can optionally define an `http` key to customize HTTP client settings:

```yaml
destination: "/opt"
http:
  connectTimeout: 30  # HTTP connect timeout in seconds. Default: 10 seconds
  requestTimeout: 300 # HTTP request timeout in seconds. Default: 900 seconds (15 minutes)
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
```

If your organization uses a custom Certificate Authority, you may need to configure a TrustStore:

```yaml
destination: "/opt"
http:
  ssl:
    trustStore:
      path: "/path/to/truststore" # Location of the TrustStore file containing trusted CA certificates.
                                  # Default: lib/security/cacerts or jre/lib/security/cacerts under JavaHome, which ToolFetch resolves from the first valid java executable on $PATH;
                                  # otherwise the bundled default TrustStore
      type: "PKCS12"              # TrustStore type. Default: autodetected. Set the type if autodetection fails
      # If the TrustStore is password-protected, specify the password using the TOOLFETCH_HTTP_SSL_TRUSTSTORE_PASSWORD environment variable
tools:
  - id: "toolfetch"
    version: "0.0.7"
    url: "https://github.com/jdheim/toolfetch/releases/download/v${version}/toolfetch-${version}-linux-amd64.tar.gz"
```

Otherwise, you may encounter an exception like this:

```text
(certificate_unknown) PKIX path building failed:
sun.security.provider.certpath.SunCertPathBuilderException:
unable to find valid certification path to requested target
```

!!! note

    TrustStore precedence:

    1. `http.ssl.trustStore.path`
    2. `JavaHome/lib/security/cacerts` (JDK 9+)
    3. `JavaHome/jre/lib/security/cacerts` (JDK 8)
    4. The bundled default TrustStore

!!! tip

    ToolFetch resolves `JavaHome` from the first valid `java` executable on `$PATH`. If you [import a Certificate for the CA](https://dev.java/learn/jvm/tool/security/keytool/#importing-for-ca) into `JavaHome/lib/security/cacerts` or `JavaHome/jre/lib/security/cacerts`, you do not need to configure `http.ssl.trustStore`.

## Archive and Compression Formats

Currently, the following Archive Formats are supported:

- `tar`
- `zip`
- `jar`

!!! warning

    `7z` support is planned

and Compression Formats:

- `brotli`
- `bzip2`
- `deflate`
- `gzip`
- `lz4`
- `lzma`
- `pack200` (for `jars`)
- `snappy` (excluding `iwa`)
- `xz`
- `z`
- `zstandard`
- concatenated streams for `bzip2`, `gzip`, `xz` and `lz4`

## Troubleshooting

ToolFetch stores log messages, including `DEBUG` messages, and exception stack traces in `.toolfetch/toolfetch.log` under the user's home directory.

The log file is overwritten on each run. Console output includes messages at `INFO` level and above. `DEBUG` level messages are available in the log
file for troubleshooting.

If you encounter an issue with ToolFetch, report it in [GitHub Issues](https://github.com/jdheim/toolfetch/issues). Describe the issue in detail,
include `toolfetch.log` and steps to reproduce it.
