# PL Reading Group

This project includes information about our Programming Languages (PL)
reading group. See the website link (in sidebar) for a more detailed
description. This repository contains the source of that website, and
tooling for selecting papers to read. We select papers ~randomly from
top PL conferences from their most recent year.

## In this Repository :wave:

The content of this repository is organized as follows:

- **`docs`** -- the website content, in markdown.
- **`data`** -- mostly generate files, for paper selection purpose.
- **`src`** -- source code for randomly choosing papers.
- **`.github/workflows`** -- github actions definitions.

The paper selection is mostly automatic, with an automatic GitHub action
set to suggest the next paper. Repo maintainers are asked to approve or
reject and rerun this suggestion.

## Guide for editing this repository :pencil2:

This section describes to most commonly expected changes.

**How to edit source conferences?**

The conference sources are in [`sources.txt`](data/sources.txt), one per
line. Change these sources, then run `npm run update` to regenerate a
dataset of papers. This process will take up to a few minutes, depending
on the number of new papers.

**How to filter papers by specific keywords?**

"Stopwords" is a list of keywords where, if any of them appear in the
paper title, that paper is not considered for selection. Edit this list
by changing [`stopwords.txt`](data/stopwords.txt). Each line is
considered a separate stopword, and paper is evaluated against each word
in this list.

**How to change the website content?**

Edit files in `docs` in markdown. Note that in some places there are
clear markers for automatically injecting text. Do not remove these
markers, or make edits between these markers. Editing anywhere else is
fine.

**How to get a suggestion for next paper?**

Run the ["Choose paper"](/actions/workflows/choose.yaml) action.
Look for "run workflow". This will generate a PR with a suggestion.

## Notes for forking

To get the automatic actions to work properly, you must enable
in repository [settings > action](settings/actions) under workflow permissions:  

1. read and write permissions
2. permission to create and approve pull requests.