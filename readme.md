# Programming Languages Reading Group

![GitHub last commit](https://img.shields.io/github/last-commit/the-au-forml-lab/plgroup)
[![Choose paper](https://github.com/the-au-forml-lab/plgroup/actions/workflows/choose.yaml/badge.svg)](https://github.com/the-au-forml-lab/plgroup/actions/workflows/choose.yaml)
[![Maintainability](https://api.codeclimate.com/v1/badges/b10b07ed0fded196aaa2/maintainability)](https://codeclimate.com/github/the-au-forml-lab/plgroup/maintainability)

**This project includes information about our programming languages reading group.**

Augusta University Programming Languages (PL) Reading Group is a regular meeting to discuss exciting recent results in programming languages research. 
The intent of the group is to learn about various ideas and generally broaden perspectives on PL research topics.
This repository contains a small website and tooling for selecting papers to read.
We select papers randomly from top programming languages conferences.

**HOW IT WORKS**

There are two available workflows. We use the "ranked choice voting" workflow.

<p align="center">
<img width="800" alt="workflow" src='https://raw.githubusercontent.com/the-au-forml-lab/plgroup/main/.github/assets/voting.png' />
</p>

<details>
  <summary>Alternative workflow</summary>
  The "random paper" workflow automatically generates 1 paper suggestion for approval.<br/><br/>
  <p align="center">
    <img width="700" alt="workflow" src='https://raw.githubusercontent.com/the-au-forml-lab/plgroup/main/.github/assets/workflow.png' />
  </p>
</details>

## In this Repository

The content of this repository is organized as follows:

| Directory               | Description                                    |
|:------------------------|:-----------------------------------------------|
| **`.github/workflows`** | GitHub actions for automation                  |
| **`data`**              | static and generated files for paper selection |
| **`docs`**              | website content                                |
| **`src`**               | source code for choosing papers                |

The paper selection is mostly automatic, with a scheduled GitHub action set to suggest the next paper.
The suggestions appear as pull requests. The paper selection is completed by merging a PR. The merge is always done by human user.

**Available commands**

```
npm run update             : update paper dataset
npm run stats              : display paper dataset statistics
npm run choose             : choose next paper
npm run web                : auto-update web page 
npm run set -- [doi]       : manually set the next paper
npm run details -- [doi]   : print meta data about a paper
```

Running these commands requires [Node.js](https://nodejs.org/en/download/).

The back-end for DOI lookups is [Crossref API](https://github.com/the-au-forml-lab/plgroup/blob/main/src/config.js#L6).

## Guide for editing this repository

This section describes to how to apply the most commonly expected changes.

**How to edit source conferences?**

The conference sources are in [`sources.txt`](data/sources.txt), one per line.
Change these sources, then run `npm run update` to regenerate a dataset of papers.
This process will take up to a few minutes, depending on the number of new papers.
The update is additive. To remove older entries, first delete `data/papers.json`.

**How to filter papers by specific keywords?**

"Stopwords" is a list of keywords where, if any of them appear in the paper title, that paper is not considered for selection.
Edit this list by changing [`stopwords.txt`](data/stopwords.txt).
Each line is considered a separate stop word, and paper is evaluated against each word in this list (case-insensitive match).

**How to change the website content?**

Edit files in [`docs`](docs) written in markdown.
The website theme is from [here](https://github.com/the-au-forml-lab/the-au-forml-lab.github.io). 
You can override desired parts and customize the site following [Jekyll docs](https://jekyllrb.com/docs/themes/#overriding-theme-defaults).

**How to get a suggestion for next paper?**

The workflows are set to run automatically, but they can be triggered manually if needed and enabled.
Run the "random paper" action or "vote open" action in [actions]](https://github.com/the-au-forml-lab/plgroup/actions). 
The option to "run workflow" is available based on repository permissions.
This will generate appropriate PRs with a paper suggestion.

**How to change the paper selection schedule**

The paper selections workflows run on schedule.
To change the schedule, follow [these instructions](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule).
It is also possible to pause the workflows without code changes from repository settings (secrets and variables > actions > variables).

## Semester maintenance
  
### Start of semester

1. Review and update [`sources.txt`](data/sources.txt)
2. If sources were updated in step 1, run 

   ```
   rm -rf data/papers.json && npm run update
   ```
   
3.  Update semester docs

    First, set appropriate values for `SEM` and `YEAR` variables. 
    Then, run the command to archive the corresponding semester.
    
    ````shell
    SEM=fall && YEAR=2023 \
    && DOCS=docs/ && DATA=data/ \
    && OLD_DIR=$DOCS"_past_semesters/"$YEAR"_"$SEM \
    && mkdir -p $OLD_DIR \
    && cp $DOCS"index.md" $OLD_DIR"/index.md" \
    && mv $DOCS"papers.md" $OLD_DIR"/papers.md" \
    && [ ! -f $DOCS"awards.md" ] || mv $DOCS"awards.md" $OLD_DIR"/awards.md" \
    && echo '' > $DOCS"/next.md" \
    && echo '' > $DATA"/past.txt" \
    && echo '' > $DATA"/next.txt" \
    && touch $DOCS"papers.md"
    ````
    
    Edit `docs/index.md` front-matter to describe the current or upcoming semester.

4. Turn on paper selection workflow in _settings > secrets and variables > actions_:  
   - To use random paper suggestion, set `PAPER_CHOOSE_ON` value to `1`
   - To use ranked choice voting, set `PAPER_VOTE_ON` value to `1`

### End of semester

1. Turn off paper selection workflow in _settings > secrets and variables > actions_:  
   Confirm `PAPER_CHOOSE_ON` and `PAPER_VOTE_ON` values are set to `0`
2. Clear the next paper selection. You can include a custom message in the quotes: 

   ```
   echo '' > docs/next.md
   ```

## Notes for forking

The repository code is generic in the sense that, by changing the conference [`sources.txt`](data/sources.txt), it can be made to suggest any kinds of papers that have DOIs indexed by Crossref.
To get the automatic actions to work properly, complete the following steps.

#### Configuration tasks TODO

* **Create issue labels** `next-paper` and `paper-vote`.
* **Enable workflow permissions** in _settings > actions > general_:
    - choose "Read and write permissions"
    - check "Allow GitHub Actions to create and approve pull requests"
* **Create expected environment variables** in _settings > secrets and variables > actions (variables)_:
    - `PAPER_CHOOSE_ON` with value `0` or `1`, off or on.
    - `PAPER_VOTE_ON` with value `0` or `1`, off or on.
    - `REVIEWERS` a newline-separated string of GitHub usernames affiliated with repository/organization.
* **Create expected environment secrets** in _settings > secrets and variables > actions (secrets)_:
    - `AUTOMERGE_PAT` a personal access token of a user with repository write access, to auto-merge PRs.
    - `DISCORD_WEBHOOK_URL` to enable discord integration (this is required for voting workflow).
