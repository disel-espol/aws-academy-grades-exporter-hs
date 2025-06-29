# aws academy grade exporter

This is a CLI tool to export grades from AWS Academy courses to different sinks.

For example, say you export the data to a SQL database. Now you can run queries
on the data to get aggregated results and such.

## Installation

Grab a binary from the releases page, or install with `cabal`:

```bash
cabal install aws-academy-grade-exporter
```

If the name is too much to type, you can create an alias for it in your shell:

```bash
alias awse='aws-academy-grade-exporter'
```

## Usage

```
aws-academy-grade-exporter - a tool for exporting grades from AWS Academy to
various formats

Usage: aws-academy-grade-exporter (-d|--destination ARG) (-f|--file ARG)

  Export grade from AWS Academy to various different formats

Available options:
  -d,--destination ARG     Where to export the data
  -f,--file ARG            The file to be processed
  -h,--help                Show this help text
```

## Sinks

### Stdout

Just prints the data to standard output.

### PostgreSQL

Will create tables based on the input data and populate them with the fields in
the file. It will additionally fetch the students' name and last name and
insert it in the table for easier mapping in AulaVirtual.

> [!NOTE]
> This sink requires a `DB_URL` environment variable to be set.

## License
MIT
